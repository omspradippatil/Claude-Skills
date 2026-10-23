---
name: mobile-engineering
description: >-
  Activate this skill for mobile app development, React Native, Flutter, Swift, native bridges, or mobile UX.
---

# Mobile Engineering Skill

## React Native

### Platform-Specific Code
```typescript
import { Platform, StyleSheet } from 'react-native';

// Inline platform check
const shadowStyle = Platform.select({
  ios: { shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 4 },
  android: { elevation: 4 },
});

// Platform-specific file extensions (auto-resolved by Metro)
// Button.ios.tsx  — loaded on iOS
// Button.android.tsx — loaded on Android
// Button.tsx — fallback

// Check OS version
if (Platform.OS === 'ios' && parseInt(Platform.Version as string, 10) >= 16) {
  // iOS 16+ specific behavior
}
```

### Performance Optimization
```typescript
// FlatList — always provide keyExtractor, getItemLayout for fixed-height items
<FlatList
  data={items}
  keyExtractor={(item) => item.id}
  renderItem={renderItem}
  getItemLayout={(_, index) => ({ length: ITEM_HEIGHT, offset: ITEM_HEIGHT * index, index })}
  maxToRenderPerBatch={10}
  windowSize={5}
  removeClippedSubviews={true}
  initialNumToRender={20}
/>

// Memoize expensive components
const ItemCard = React.memo(({ item }: { item: Item }) => {
  return <View>...</View>;
}, (prev, next) => prev.item.id === next.item.id && prev.item.updatedAt === next.item.updatedAt);

// Stable callback references
const handlePress = useCallback((id: string) => {
  navigation.navigate('Detail', { id });
}, [navigation]);
```

### Navigation Patterns (React Navigation)
```typescript
// Stack + Tab hybrid
const RootStack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<TabParamList>();

// Typed params
type RootStackParamList = {
  Main: NavigatorScreenParams<TabParamList>;
  Detail: { postId: string };
  Modal: undefined;
};

// Deep linking config
const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['myapp://', 'https://myapp.com'],
  config: {
    screens: {
      Detail: 'posts/:postId',
    },
  },
};
```

### Native Modules
```typescript
// Calling a native module
import { NativeModules, NativeEventEmitter } from 'react-native';

const { BiometricModule } = NativeModules;

async function authenticateWithBiometrics(): Promise<boolean> {
  try {
    return await BiometricModule.authenticate('Confirm your identity');
  } catch (e) {
    return false;
  }
}

// Listen to native events
const emitter = new NativeEventEmitter(NativeModules.LocationModule);
const sub = emitter.addListener('onLocationUpdate', handleLocationUpdate);
// Always remove listener on unmount
useEffect(() => () => sub.remove(), []);
```

### Bridge Overhead
- Minimize bridge calls in render paths — batch operations where possible
- Use the **New Architecture (JSI/TurboModules/Fabric)** for zero-copy synchronous native calls
- Prefer `react-native-reanimated` (runs on UI thread) over `Animated` API for smooth 60fps animations
- Avoid passing large objects across the bridge; serialize only necessary data

---

## Flutter

### Widget Rebuild Optimization
```dart
// Use const constructors wherever possible
const MyWidget({super.key});

// const widgets never rebuild
const Text('Static label')

// Prefer Consumer over context.watch at the leaf level
Consumer<CounterModel>(
  builder: (context, counter, child) {
    return Text('${counter.value}'); // only this rebuilds
  },
)

// Use RepaintBoundary to isolate expensive subtrees
RepaintBoundary(child: ExpensiveChart())
```

### State Management — Riverpod
```dart
// Provider definition (outside widget)
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  return ref.watch(userRepositoryProvider).getCurrentUser();
});

// In widget
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
      data: (user) => UserProfile(user: user),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => ErrorWidget(e.toString()),
    );
  }
}
```

### BLoC Pattern
```dart
// Cubit (simpler BLoC)
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());

  final AuthRepository _authRepo;

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signIn(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
```

### Selective Rebuilds
- `Selector<T, S>` in Provider: only rebuilds when selected value changes
- `riverpod` `select`: `ref.watch(userProvider.select((u) => u.name))`
- Break large widgets into smaller ones; Flutter rebuilds at widget boundaries
- Use `ListView.builder` (not `ListView`) for long lists

---

## Swift / iOS

### SwiftUI Patterns
```swift
// ViewModel with @Observable (iOS 17+) or ObservableObject
@Observable
final class PostViewModel {
    var posts: [Post] = []
    var isLoading = false
    var error: Error?

    private let repository: PostRepository

    init(repository: PostRepository = .live) {
        self.repository = repository
    }

    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            posts = try await repository.fetchPosts()
        } catch {
            self.error = error
        }
    }
}

// View
struct PostListView: View {
    @State private var viewModel = PostViewModel()

    var body: some View {
        List(viewModel.posts) { post in
            PostRow(post: post)
        }
        .task { await viewModel.loadPosts() }
        .overlay { if viewModel.isLoading { ProgressView() } }
    }
}
```

### Async/Await & Concurrency
```swift
// Structured concurrency
func fetchDashboard() async throws -> Dashboard {
    async let user = userService.fetchCurrentUser()
    async let posts = postService.fetchRecentPosts()
    return Dashboard(user: try await user, posts: try await posts)
}

// Actor for shared mutable state
actor ImageCache {
    private var cache: [URL: UIImage] = [:]

    func image(for url: URL) -> UIImage? { cache[url] }
    func store(_ image: UIImage, for url: URL) { cache[url] = image }
}
```

### Memory Management
- Use `[weak self]` in closures that capture `self` to avoid retain cycles
- Prefer `struct` over `class` for value types (models, view state)
- Use `deinit` to cancel `AnyCancellable` subscriptions and invalidate timers
- Profile with Instruments (Leaks, Allocations) before shipping

---

## Mobile Security (OWASP MASVS)

### No Hardcoded Secrets
- **Never** hardcode API keys, tokens, or credentials in source code
- Use environment-specific config (xcconfig, build variants, `.env` via react-native-config)
- Runtime secrets should be fetched from a secure backend after authentication

### Secure Storage
```swift
// iOS Keychain
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: "auth_token",
    kSecValueData as String: tokenData,
    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
]
SecItemAdd(query as CFDictionary, nil)
```

```kotlin
// Android EncryptedSharedPreferences
val masterKey = MasterKey.Builder(context)
    .setKeyScheme(MasterKey.KeyScheme.AES256_GCM).build()

val prefs = EncryptedSharedPreferences.create(
    context, "secure_prefs", masterKey,
    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
)
prefs.edit().putString("auth_token", token).apply()
```

### Certificate Pinning
- Pin for high-value apps (banking, healthcare) using `TrustKit` (iOS) or `OkHttp CertificatePinner` (Android)
- Include backup pins and a rotation plan — pinning without a plan causes outages on cert renewal
- For React Native: `react-native-ssl-pinning` or native module

### Additional MASVS Controls
- Disable screenshot capture on sensitive screens (iOS: `isSecureTextEntry`, Android: `FLAG_SECURE`)
- Clear clipboard after a short delay for copied passwords
- Validate all data from the server — don't trust `200 OK` blindly
- Implement root/jailbreak detection for high-security apps

---

## Performance

### Image Caching
- **React Native**: `react-native-fast-image` (uses SDWebImage/Fresco under the hood)
- **Flutter**: `CachedNetworkImage` package
- **iOS**: `Kingfisher` or `SDWebImage`
- Always use thumbnails in lists; load full-res only on detail view

### Startup Time
- Defer non-critical initialization after first render (`InteractionManager.runAfterInteractions` in RN)
- Use lazy imports / deferred module loading
- Measure with Xcode Instruments Time Profiler and Android Systrace
- Minimize main thread work during cold start

### Bundle Size
- Enable Hermes (React Native) for faster TTI and smaller bundle
- Use `--analyzer` in Flutter to identify large packages
- Remove unused assets; use vector icons (`react-native-vector-icons`) instead of bitmap icon sets
- Disable debug builds' source maps from production bundle

---

## Testing

### React Native
```typescript
// Unit test with Jest + Testing Library
import { render, fireEvent, waitFor } from '@testing-library/react-native';

test('loads and displays posts', async () => {
  const { getByText } = render(<PostListScreen />);
  await waitFor(() => expect(getByText('My First Post')).toBeTruthy());
});
```

### Flutter Widget Tests
```dart
testWidgets('shows loading indicator then list', (tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  await tester.pumpAndSettle();
  expect(find.byType(PostCard), findsWidgets);
});
```

### Integration / E2E
- **React Native**: Detox (gray-box testing, controls real device/simulator)
- **Flutter**: `integration_test` package with `flutter drive`
- **iOS**: XCUITest
- Run on real devices for camera, biometrics, push notification testing — simulators are insufficient
