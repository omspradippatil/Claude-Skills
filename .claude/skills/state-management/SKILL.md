---
name: state-management
description: >-
  Activate this skill for complex frontend state, React Query/SWR data fetching, Zustand/Redux global stores, or XState.
---

# State Management Skill

## State Taxonomy

Before picking a library, classify your state:

| Type | Definition | Best Tool |
|---|---|---|
| **Server state** | Data fetched from an API — async, cacheable, shared | TanStack Query, SWR |
| **Global client state** | App-wide synchronous state (user session, theme, cart) | Zustand, Redux Toolkit |
| **URL state** | State that lives in the URL (filters, pagination, tab) | `useSearchParams`, router |
| **Form state** | Ephemeral input values, validation errors | React Hook Form |
| **Local UI state** | Component-scoped toggles, open/close — not shared | `useState`, `useReducer` |
| **Complex flow state** | Multi-step wizards, async state machines | XState |

> **Rule**: reach for the simplest tool that fits. Local UI state belongs in `useState`, not a global store.

---

## TanStack Query (React Query)

### Query Keys
```typescript
// Centralize query keys in a factory
export const postKeys = {
  all: ['posts'] as const,
  lists: () => [...postKeys.all, 'list'] as const,
  list: (filters: PostFilters) => [...postKeys.lists(), filters] as const,
  details: () => [...postKeys.all, 'detail'] as const,
  detail: (id: string) => [...postKeys.details(), id] as const,
};

// Usage
const { data } = useQuery({
  queryKey: postKeys.detail(postId),
  queryFn: () => api.getPost(postId),
  staleTime: 5 * 60 * 1000, // 5 minutes — don't refetch if fresh
});
```

### Cache Invalidation
```typescript
const queryClient = useQueryClient();

// After mutation: invalidate list queries (refetch in background)
const mutation = useMutation({
  mutationFn: api.createPost,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: postKeys.lists() });
  },
});
```

### Optimistic Updates
```typescript
const mutation = useMutation({
  mutationFn: api.updatePost,
  onMutate: async (updatedPost) => {
    // Cancel in-flight queries for this post
    await queryClient.cancelQueries({ queryKey: postKeys.detail(updatedPost.id) });

    // Snapshot previous value
    const previous = queryClient.getQueryData<Post>(postKeys.detail(updatedPost.id));

    // Optimistically update cache
    queryClient.setQueryData(postKeys.detail(updatedPost.id), updatedPost);

    return { previous }; // context for rollback
  },
  onError: (err, variables, context) => {
    // Rollback on error
    queryClient.setQueryData(postKeys.detail(variables.id), context?.previous);
  },
  onSettled: (_, __, variables) => {
    queryClient.invalidateQueries({ queryKey: postKeys.detail(variables.id) });
  },
});
```

### Prefetching
```typescript
// Prefetch on hover for instant navigation
const handleHover = () => {
  queryClient.prefetchQuery({
    queryKey: postKeys.detail(postId),
    queryFn: () => api.getPost(postId),
    staleTime: 10 * 1000,
  });
};

// Server-side prefetch (Next.js)
export async function getServerSideProps() {
  const queryClient = new QueryClient();
  await queryClient.prefetchQuery({ queryKey: postKeys.lists(), queryFn: api.getPosts });
  return { props: { dehydratedState: dehydrate(queryClient) } };
}
```

### Stale-While-Revalidate Strategy
- `staleTime`: how long data is considered fresh (no background refetch)
- `gcTime` (cacheTime): how long unused data stays in cache before garbage collection
- Pattern: `staleTime: 60_000` (show cached data for 60s), `gcTime: 5 * 60_000` (keep in memory for 5min)

---

## SWR

```typescript
import useSWR from 'swr';

const fetcher = (url: string) => fetch(url).then(r => r.json());

function PostDetail({ id }: { id: string }) {
  const { data, error, isLoading, mutate } = useSWR<Post>(`/api/posts/${id}`, fetcher, {
    revalidateOnFocus: true,       // refetch when window regains focus
    revalidateOnReconnect: true,   // refetch after going online
    dedupingInterval: 2000,        // dedupe requests within 2s
  });

  // Manual revalidation after mutation
  const handleDelete = async () => {
    await api.deletePost(id);
    mutate(undefined, { revalidate: false }); // clear cache
  };
}
```

- SWR is simpler than TanStack Query; prefer TanStack Query for apps needing optimistic updates, dependent queries, or infinite scroll
- SWR's `mutate` can be used globally: `import { mutate } from 'swr'`

---

## Zustand

### Slice Pattern
```typescript
// features/auth/authSlice.ts
import { StateCreator } from 'zustand';

interface AuthSlice {
  user: User | null;
  signIn: (credentials: Credentials) => Promise<void>;
  signOut: () => void;
}

export const createAuthSlice: StateCreator<RootStore, [], [], AuthSlice> = (set) => ({
  user: null,
  signIn: async (credentials) => {
    const user = await authApi.signIn(credentials);
    set({ user });
  },
  signOut: () => set({ user: null }),
});

// store.ts — combine slices
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

export const useStore = create<RootStore>()(
  devtools(
    persist(
      (...args) => ({
        ...createAuthSlice(...args),
        ...createCartSlice(...args),
      }),
      { name: 'app-store', partialize: (state) => ({ user: state.user }) } // only persist user
    ),
    { name: 'AppStore' }
  )
);
```

### Derived State
```typescript
// Derive outside the store using selectors to avoid over-subscription
const cartTotal = useStore((state) =>
  state.cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0)
);
```

### Devtools
- Install Redux DevTools browser extension — Zustand devtools middleware connects automatically
- Name your store actions for readable time-travel debugging: `set({ count: count + 1 }, false, 'counter/increment')`

---

## Redux Toolkit

### Slices
```typescript
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

const postsSlice = createSlice({
  name: 'posts',
  initialState: [] as Post[],
  reducers: {
    postAdded(state, action: PayloadAction<Post>) {
      state.push(action.payload); // Immer allows mutations
    },
    postRemoved(state, action: PayloadAction<string>) {
      return state.filter(p => p.id !== action.payload);
    },
  },
});

export const { postAdded, postRemoved } = postsSlice.actions;
```

### RTK Query
```typescript
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

export const postsApi = createApi({
  reducerPath: 'postsApi',
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  tagTypes: ['Post'],
  endpoints: (builder) => ({
    getPosts: builder.query<Post[], void>({
      query: () => '/posts',
      providesTags: ['Post'],
    }),
    createPost: builder.mutation<Post, Partial<Post>>({
      query: (body) => ({ url: '/posts', method: 'POST', body }),
      invalidatesTags: ['Post'], // auto-refetch getPosts after mutation
    }),
  }),
});

export const { useGetPostsQuery, useCreatePostMutation } = postsApi;
```

---

## XState

### State Machines for Complex Flows
```typescript
import { createMachine, assign } from 'xstate';

const checkoutMachine = createMachine({
  id: 'checkout',
  initial: 'cart',
  context: { items: [], paymentError: null },
  states: {
    cart: {
      on: {
        PROCEED: 'address',
        ADD_ITEM: { actions: assign({ items: ({ context, event }) => [...context.items, event.item] }) },
      },
    },
    address: {
      on: { BACK: 'cart', SUBMIT: 'payment' },
    },
    payment: {
      on: {
        PAY: {
          target: 'processing',
          guard: ({ context }) => context.items.length > 0,
        },
        BACK: 'address',
      },
    },
    processing: {
      invoke: {
        src: 'processPayment',
        onDone: 'confirmation',
        onError: {
          target: 'payment',
          actions: assign({ paymentError: ({ event }) => event.error.message }),
        },
      },
    },
    confirmation: { type: 'final' },
  },
});
```

- Use XState for multi-step forms, authentication flows, media players, drag-and-drop
- Visualize machines with [stately.ai](https://stately.ai) — invaluable for complex flows
- The actor model (`spawn`, `spawnChild`) handles parent-child machine communication

---

## Form State — React Hook Form + Zod

```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'At least 8 characters'),
  age: z.coerce.number().int().min(18, 'Must be 18+'),
});

type FormValues = z.infer<typeof schema>;

function SignUpForm() {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '' },
  });

  const onSubmit = async (data: FormValues) => {
    await api.signUp(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
      <button type="submit" disabled={isSubmitting}>Sign Up</button>
    </form>
  );
}
```

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| **Prop drilling** | Passing props 4+ levels deep | Lift to Zustand/Context or co-locate |
| **Over-fetching** | Fetching more data than the component needs | Select specific fields; use query params |
| **Under-caching** | Fetching same data on every mount | Use TanStack Query with appropriate `staleTime` |
| **Everything in Redux** | Simple local state in global store | Keep toggle state in `useState` |
| **No query key structure** | Ad-hoc string keys cause stale cache bugs | Use query key factories |
| **Missing loading/error states** | UI hangs or crashes silently | Always handle `isLoading` and `error` in query hooks |
| **Mutating Redux state directly** | Runtime errors, missed updates | Use RTK slices (Immer) or `...spread` |
| **XState for simple toggles** | Over-engineering | `useState(false)` is fine for a modal |
