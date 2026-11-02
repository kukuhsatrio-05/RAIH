# CODER PROFILE - PARTNER CODING STYLE

Dokumen ini mencatat gaya coding, pola, dan konvensi yang digunakan oleh partner dalam proyek RAIH.

## STRUKTUR PROYEK

**Architecture:**
- Feature-based organization (Clean Architecture simplified)
- Separation: Data, Presentation, Models, UI
- Core layer untuk shared utilities

**Folder Structure:**
```
lib/
├── app/           # Application config (router, di)
├── core/         # Shared utilities (constants, theme, widgets, errors)
├── features/     # Feature modules
│   ├── auth/     # Authentication
│   │   ├── data/
│   │   ├── presentation/
│   │   └── widgets/
│   ├── home/
│   ├── mading/
│   └── ... other features
├── model/        # Shared models (if any)
└── ui/           # Global UI components
```

## CODING CONVENTIONS

### 1. **STATE MANAGEMENT (Riverpod)**
**Pattern:**
- RepositoryProvider untuk data layer
- NotifierProvider untuk view models
- AsyncNotifierProvider untuk async state
- State classes dengan `copyWith()` method

**Naming:**
- `*Repository` (data access)
- `*ViewModel` atau `*Controller` (presentation logic)
- `*Provider` (Provider instance)
- `*State` (immutable state class)

**Example:**
```dart
class AuthStateNotifier extends AsyncNotifier<UserEntity?>
final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, UserEntity?>
```

### 2. **DATA MODELS**
**Pattern:**
- Immutable data classes
- Factory constructors (`fromMap`, `fromJson`)
- `toMap()` methods for serialization
- Optional fields with default values
- Named constructors with `required` parameters

**Naming:**
- `*Model` suffix
- Snake case in `fromMap()` keys (matching database columns)

**Example:**
```dart
class MadingModel {
  final String id;
  final String title;
  // ... other fields

  factory MadingModel.fromMap(Map<String, dynamic> map) {
    return MadingModel(
      id: map['id']?.toString() ?? '',  // null safety with default
      title: map['title'] as String? ?? '',
    );
  }
}
```

### 3. **STATE CLASSES**
**Pattern:**
- Immutable with `copyWith()`
- Computed properties (getters) for derived state
- Default values in constructor

**Example:**
```dart
class EventState {
  final List<EventModel> allEvents;
  final String filterType;
  final String filterSubCategory;

  const EventState({
    required this.allEvents,
    this.filterType = 'Semua',
    this.filterSubCategory = 'Semua Kategori',
  });

  EventState copyWith({...}) => EventState(...);
}
```

### 4. **ERROR HANDLING**
**Pattern:**
- `try-catch-finally` blocks
- State updates with error handling
- Async operations with `AsyncValue.guard()`
- Silent error handling for non-critical operations

**Example:**
```dart
Future<void> loadUser() async {
  state = state.copyWith(isLoading: true);
  try {
    final user = await authRepository.getCurrentUser();
    state = state.copyWith(isLoading: false, user: user);
  } catch (e) {
    state = state.copyWith(isLoading: false); // Error silently handled
  }
}
```

### 5. **WIDGETS & UI**
**Pattern:**
- StatelessWidget dengan final properties
- Widget composition over inheritance
- Custom widget classes for reusability
- Responsive layout with `LayoutBuilder`
- Error builders for network images

**Naming:**
- `*Card`, `*Header`, `*Layout` suffix
- PascalCase for widget classes

**Example:**
```dart
class MadingCard extends StatelessWidget {
  final MadingModel item;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Styling with AppColors and AppTextStyles
      ),
    );
  }
}
```

### 6. **CONSTANTS & CONFIG**
**Pattern:**
- Static classes for constants
- Environment variables via `flutter_dotenv`
- Color and text theme classes

**Naming:**
- `*Constants` (e.g., `EnvConstants`, `AppConstants`)
- `get` prefix for computed properties

**Example:**
```dart
class EnvConstants {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
}
```

### 7. **THEMING**
**Pattern:**
- Material 3 enabled (`useMaterial3: true`)
- ColorScheme from seed colors
- Google Fonts (Poppins) integration
- Custom color palette in `AppColors`
- Text styles in `AppTextStyles`

**Example:**
```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blueNormal,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}
```

## LIBRARY USAGE PATTERNS

### **Riverpod:**
- `Notifier` for simple state
- `AsyncNotifier` for async operations
- `Provider` for repositories/singletons
- `ref.read()` in async methods, `ref.watch()` in build()

### **Supabase:**
- Supabase client via provider
- Table constants in `SupabaseTables`
- Direct auth methods usage

### **Google Sign-In:**
- Configured with server client ID
- Integration with Supabase auth

### **Navigation:**
- GoRouter configured (currently commented)
- Direct navigation to screens

## INDONESIAN LANGUAGE USAGE

**Code Comments:**
- Mostly Indonesian comments
- `// TODO:` comments in English
- Mix of Indonesian and English variable names

**Variable Naming:**
- Field names: English (`id`, `title`, `imageUrl`)
- UI labels: Indonesian ('Semua Kategori', 'Pendaftaran')
- Method names: English (`getCurrentUser`, `signInWithGoogle`)

## TODO PATTERNS

**Unfinished Code:**
- Repository methods have `// TODO: Query Supabase table` comments
- Router configuration commented out
- Dummy data in controllers

**Example TODOs:**
```dart
// TODO: Query Supabase table atau panggil Supabase Auth/Storage
Future<UserEntity> loginWithEmail(String email, String password) async {
```

## CONFIGURATION PATTERNS

### **Environment:**
- `.env` file loading
- API keys in environment variables
- Multi-platform support

### **Assets:**
- Images in `assets/images/`
- Icons in `assets/icons/`
- Fonts in `assets/fonts/`
- SVG support

### **Build Config:**
- Native splash screen configuration
- Adaptive launcher icons
- Multi-platform build support

## TESTING APPROACH

**Current State:**
- Test folder exists but minimal tests
- Dummy data for development
- Error handling in place

## BEST PRACTICES FOLLOWED

1. **Null Safety:** Extensive use of `??` operator, `?.` navigation
2. **Immutability:** Final fields, `copyWith()` pattern
3. **Separation of Concerns:** Clear data/presentation separation
4. **Dependency Injection:** Riverpod providers for dependencies
5. **Error Resilience:** Graceful fallbacks (image error builders)
6. **Performance:** `const` constructors where possible
7. **Responsiveness:** LayoutBuilder for dynamic sizing

## AREAS FOR IMPROVEMENT

1. **Testing:** Limited test coverage
2. **Documentation:** Sparse method documentation
3. **Error Reporting:** Silent error handling may hide issues
4. **Router:** GoRouter not fully configured
5. **Localization:** Mixed language usage

## PREFERENCES TO MAINTAIN

1. **Color System:** `AppColors` with semantic names (blueNormal, whiteDarker)
2. **Text Styles:** `AppTextStyles` for consistent typography
3. **State Management:** Riverpod with Notifier/AsyncNotifier pattern
4. **Folder Structure:** Feature-based organization
5. **Model Serialization:** `fromMap`/`toMap` pattern for database mapping

---

*Dokumen ini diperbarui terakhir: 2026-11-02*  
*Gunakan sebagai panduan konsistensi saat melanjutkan pengembangan proyek.*