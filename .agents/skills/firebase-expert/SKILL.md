---
name: firebase-expert
description: >-
  Activate this skill for Firebase/Firestore schema design, Security Rules, Cloud Functions, or Firebase Auth.
---

# Firebase Expert Skill

## Firebase Authentication

### Providers & Configuration
- Email/password, Google, Apple, Facebook, GitHub, phone — configure each in Firebase Console under Authentication > Sign-in method
- Authorized domains must be explicitly listed; localhost is added by default for development
- OAuth redirect URIs must match exactly — a common source of "unauthorized domain" errors

### Custom Claims
- Set via Admin SDK only (never client-side): `auth.setCustomUserClaims(uid, { role: 'admin' })`
- Claims appear in the ID token after next sign-in or token refresh — force refresh with `user.getIdToken(true)`
- Limit total claim payload to <1KB; store extra data in Firestore linked by UID
- Use claims for coarse-grained access (roles), Firestore rules for fine-grained document access

### Session Management
- ID tokens expire after 1 hour; use `onIdTokenChanged` listener to detect refresh
- For server-side sessions, verify tokens with Admin SDK: `auth.verifyIdToken(token)`
- Session cookies (Admin SDK `createSessionCookie`) useful for SSR apps — set `httpOnly`, `secure`, `sameSite`
- Revoke tokens on sensitive events (password change, account compromise): `auth.revokeRefreshTokens(uid)`

---

## Firestore Security Rules

### Core Patterns

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function hasRole(role) {
      return request.auth.token.role == role;
    }

    function isValidUser() {
      return isSignedIn() && request.auth.token.email_verified == true;
    }

    // User documents — owners and admins only
    match /users/{userId} {
      allow read: if isOwner(userId) || hasRole('admin');
      allow create: if isOwner(userId) && isValidNewUser();
      allow update: if isOwner(userId) && isValidUserUpdate();
      allow delete: if hasRole('admin');
    }

    // Posts — public read, authenticated write with ownership
    match /posts/{postId} {
      allow read: if resource.data.published == true || isOwner(resource.data.authorId);
      allow create: if isSignedIn() && isValidPost();
      allow update: if isOwner(resource.data.authorId) && isValidPostUpdate();
      allow delete: if isOwner(resource.data.authorId) || hasRole('admin');
    }
  }
}
```

### Field Validation in Rules
```javascript
function isValidPost() {
  let data = request.resource.data;
  return data.keys().hasAll(['title', 'authorId', 'createdAt'])
    && data.title is string && data.title.size() > 0 && data.title.size() <= 200
    && data.authorId == request.auth.uid
    && data.createdAt == request.time;  // enforce server timestamp
}

function isValidPostUpdate() {
  // Only allow updating specific fields
  let allowedFields = ['title', 'body', 'updatedAt', 'published'];
  return request.resource.data.diff(resource.data).affectedKeys().hasOnly(allowedFields);
}
```

### Ownership Checks
- Always compare `resource.data.ownerId == request.auth.uid` for document ownership
- For subcollection ownership, use `get()` to fetch parent: `get(/databases/$(database)/documents/posts/$(postId)).data.authorId`
- **Never** rely solely on client-side checks — Firestore rules are your last line of defense

### Role-Based Access
```javascript
// Read role from custom claims (preferred — no extra read)
function isAdmin() { return request.auth.token.role == 'admin'; }

// Or read from a roles collection (costs a read per check)
function isAdminFromDB() {
  return get(/databases/$(database)/documents/roles/$(request.auth.uid)).data.isAdmin == true;
}
```

### Common Rule Mistakes
- **Missing wildcard coverage**: `match /col/{doc}` does not cover subcollections — add `match /col/{doc}/{sub=**}`
- **Overly permissive wildcards**: `allow read, write: if true;` — never in production
- **Missing `.data` access on `resource`**: use `resource.data.field`, not `resource.field`
- **`request.resource` vs `resource`**: `request.resource` is the incoming data; `resource` is the existing document

---

## Realtime Database Rules

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid",
        "email": {
          ".validate": "newData.isString() && newData.val().matches(/^[^@]+@[^@]+$/)"
        }
      }
    },
    "public": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```

- Rules cascade down — a `.read: true` at a parent grants access to all children
- Use `.validate` for field-level constraints (does not cascade)
- Index frequently queried fields: `".indexOn": ["createdAt", "userId"]`

---

## Cloud Functions

### Trigger Types

```typescript
import * as functions from 'firebase-functions/v2';
import { onDocumentCreated, onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { onUserCreated } from 'firebase-functions/v2/identity';
import { onMessagePublished } from 'firebase-functions/v2/pubsub';
import { onRequest, onCall } from 'firebase-functions/v2/https';

// Firestore trigger
export const onPostCreated = onDocumentCreated('posts/{postId}', async (event) => {
  const post = event.data?.data();
  if (!post) return;
  // send notification, update counters, etc.
});

// Auth trigger
export const onNewUser = onUserCreated(async (event) => {
  const user = event.data;
  await db.collection('users').doc(user.uid).set({
    email: user.email,
    createdAt: FieldValue.serverTimestamp(),
    role: 'user',
  });
});

// Callable function (authenticated)
export const createPost = onCall({ enforceAppCheck: true }, async (request) => {
  if (!request.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');
  // perform action
  return { postId: 'new-id' };
});

// HTTP function
export const webhookHandler = onRequest(async (req, res) => {
  // verify webhook signature first
  res.json({ ok: true });
});
```

### Cold Starts & Performance
- Use **minimum instances** (`minInstances: 1`) for latency-sensitive functions
- Keep function bundles small — avoid importing entire SDKs when only parts are needed
- Initialize Admin SDK and other clients outside the function handler (module scope)
- Use `v2` functions which have improved cold start times over `v1`

### Secrets Management
```typescript
import { defineSecret } from 'firebase-functions/params';

const stripeKey = defineSecret('STRIPE_SECRET_KEY');

export const chargeCustomer = onCall({ secrets: [stripeKey] }, async (request) => {
  const stripe = new Stripe(stripeKey.value()); // accessed at runtime only
});
```
- Store secrets with: `firebase functions:secrets:set STRIPE_SECRET_KEY`
- **Never** hardcode secrets or commit them to source control
- Use `.env` files only for non-sensitive config (region, project ID)

### Deployment Patterns
```bash
# Deploy specific function
firebase deploy --only functions:onPostCreated

# Set region (co-locate with Firestore)
# In function definition:
export const myFn = onRequest({ region: 'us-central1' }, handler);
```

---

## Firebase Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // User avatars — owners only, images only, max 2MB
    match /avatars/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId
        && request.resource.size < 2 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
      allow delete: if request.auth.uid == userId;
    }

    // Post attachments — authenticated upload, public read
    match /posts/{postId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null
        && request.resource.size < 10 * 1024 * 1024;
    }
  }
}
```

---

## Critical Security Practices

- **Never expose Admin SDK credentials client-side** — Admin SDK bypasses all security rules
- Service account keys: store in Secret Manager, rotate regularly, grant minimum IAM roles
- **App Check**: enforce for production to block non-app clients
- Enable **audit logging** for Admin SDK usage in production
- Validate all data server-side in Cloud Functions even if rules exist — defense in depth
- Use Firestore transactions for counters to avoid race conditions

---

## Firebase Emulator Suite

```bash
# Start all emulators
firebase emulators:start

# Start specific emulators
firebase emulators:start --only firestore,auth,functions

# Export/import emulator data for reproducible tests
firebase emulators:export ./emulator-data
firebase emulators:start --import ./emulator-data
```

### Testing with Emulators

```typescript
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';

const testEnv = await initializeTestEnvironment({
  projectId: 'demo-test',
  firestore: { rules: fs.readFileSync('firestore.rules', 'utf8') },
});

test('owner can read own document', async () => {
  const alice = testEnv.authenticatedContext('alice');
  await assertSucceeds(alice.firestore().doc('users/alice').get());
});

test('stranger cannot read another user document', async () => {
  const bob = testEnv.authenticatedContext('bob');
  await assertFails(bob.firestore().doc('users/alice').get());
});
```

---

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Rules not covering all paths | Add `/{document=**}` wildcard for subcollections |
| Missing Firestore index on queries | Check browser console for index creation link; add to `firestore.indexes.json` |
| Exposing `.get()` fetched data in rules | Rules evaluate `.get()` results server-side — fine, but each costs a read |
| Querying without index on ordered + filtered fields | Composite index required for `where + orderBy` on different fields |
| Function timeout on large Firestore reads | Use batched reads, paginate with `startAfter`, or use Admin SDK streaming |
| Not setting `CORS` on Storage | Configure allowed origins in Storage or use a Cloud Function proxy |
| Auth state not persisted across refreshes | Ensure Firebase is initialized before rendering; use `onAuthStateChanged` |
