# 🛠️ Development Guide - Mobile Kana

This guide provides comprehensive information for developers contributing to Mobile Kana.

## 📋 Table of Contents

1. [Setup](#setup)
2. [Architecture](#architecture)
3. [Data Management](#data-management)
4. [State Management](#state-management)
5. [Adding New Features](#adding-new-features)
6. [Code Style](#code-style)
7. [Testing](#testing)
8. [Performance](#performance)

## 🚀 Setup

### Prerequisites

1. **Flutter SDK** (3.0.0 or higher)
   ```bash
   flutter doctor
   ```

2. **IDE Setup**
   - VS Code with Flutter extension, OR
   - Android Studio with Flutter plugin

3. **Platform-Specific**
   - **Android**: Android Studio, Android SDK
   - **iOS**: Xcode (macOS only), CocoaPods

### Initial Setup

```bash
# Clone the repo
git clone https://github.com/EPHRAIMTEODORO/Mobile-Kana.git
cd Mobile-Kana

# Get dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build

# Run the app
flutter run
```

### Hot Reload Tips

- Press `r` for hot reload
- Press `R` for hot restart
- Press `p` to show performance overlay

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
├── data/                     # Static data & datasets
├── providers/                # State management
├── screens/                  # Main UI screens
├── widgets/                  # Reusable components
└── utils/                    # Helper functions
```

### Design Patterns

1. **Provider Pattern**: Used for state management
   - Simple, scalable, and recommended by Flutter team
   - Each feature has its own provider (ThemeProvider, ProgressProvider, etc.)

2. **Repository Pattern**: Data access abstraction
   - `StorageHelper` handles all local storage operations
   - Separates data logic from UI

3. **Factory Pattern**: Used in model constructors
   - `fromJson()` methods for deserialization

## 📊 Data Management

### Kana Data Structure

```dart
class KanaCharacter {
  final String character;   // 'あ', 'ア'
  final String romaji;      // 'a'
  final KanaType type;      // hiragana or katakana
}
```

- Data stored in: `lib/data/hiragana_data.dart`, `katakana_data.dart`
- 46 characters each = 92 total

### Kanji Data Structure

```dart
class KanjiCharacter {
  final String character;           // '一'
  final List<String> meanings;      // ['one']
  final List<String> onyomi;        // ['イチ', 'イツ']
  final List<String> kunyomi;       // ['ひと', 'ひと.つ']
  final List<KanjiExample> examples;
  final KanjiGrade grade;
  final int? strokeCount;
  final JlptLevel? jlptLevel;
  // ... additional fields
}
```

- Data organized by grade in `lib/data/kanji/`
- 7 files: `grade1_kanji.dart` through `junior_high_kanji.dart`

### Adding Kanji Data

To expand the kanji dataset:

1. **Choose a data source** (KANJIDIC2, Kanji alive, etc.)
2. **Convert to Dart format**:

```dart
KanjiCharacter(
  character: '学',
  meanings: ['study', 'learning'],
  onyomi: ['ガク'],
  kunyomi: ['まな.ぶ'],
  examples: [
    KanjiExample(
      word: '学校',
      reading: 'がっこう',
      meaning: 'school',
    ),
  ],
  grade: KanjiGrade.grade1,
  strokeCount: 8,
  jlptLevel: JlptLevel.n5,
),
```

3. **Add to appropriate grade file**
4. **Test with `AllData.allKanji`**

### Progress Data

- Stored locally using SharedPreferences
- Format: JSON string of `CharacterProgress` list
- Auto-saved after each quiz/flashcard session

```dart
class CharacterProgress {
  final String character;
  int correct;
  int incorrect;
  DateTime lastReviewed;
  double get accuracy => correct / (correct + incorrect);
}
```

## 🔄 State Management

### Provider Overview

All providers extend `ChangeNotifier`:

```dart
class MyProvider with ChangeNotifier {
  // Private state
  int _count = 0;
  
  // Public getter
  int get count => _count;
  
  // Method that modifies state
  void increment() {
    _count++;
    notifyListeners();  // Triggers UI rebuild
  }
}
```

### Available Providers

1. **ThemeProvider** - Theme mode (light/dark)
   ```dart
   Provider.of<ThemeProvider>(context).toggleTheme();
   ```

2. **ProgressProvider** - Learning progress
   ```dart
   final provider = Provider.of<ProgressProvider>(context);
   provider.updateProgress('一', true);
   ```

3. **KanjiProvider** - Kanji browsing state
   ```dart
   final provider = Provider.of<KanjiProvider>(context);
   provider.selectGrade(KanjiGrade.grade2);
   ```

4. **QuizProvider** - Quiz session state
   ```dart
   final provider = Provider.of<QuizProvider>(context);
   provider.startKanjiQuiz(grade: KanjiGrade.grade1);
   ```

### Using Providers in Widgets

```dart
// 1. Consumer (rebuilds on change)
Consumer<ProgressProvider>(
  builder: (context, provider, child) {
    return Text('Accuracy: ${provider.overallAccuracy}');
  },
)

// 2. Provider.of (for one-time access)
final provider = Provider.of<ProgressProvider>(context, listen: false);
provider.loadProgress();

// 3. context.watch/read (shorter syntax)
final count = context.watch<ProgressProvider>().totalPracticed;
context.read<ProgressProvider>().loadProgress();
```

## ➕ Adding New Features

### Adding a New Screen

1. **Create screen file** in `lib/screens/`

```dart
// lib/screens/my_new_screen.dart
import 'package:flutter/material.dart';

class MyNewScreen extends StatelessWidget {
  const MyNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My New Screen')),
      body: const Center(child: Text('Content here')),
    );
  }
}
```

2. **Add navigation** from existing screen

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const MyNewScreen()),
);
```

3. **Add to constants** (if needed)

```dart
// lib/utils/constants.dart
class AppRoutes {
  static const String myNewScreen = '/my-new-screen';
}
```

### Adding a New Widget

1. **Create widget file** in `lib/widgets/`

```dart
// lib/widgets/my_custom_widget.dart
import 'package:flutter/material.dart';

class MyCustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MyCustomWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
```

2. **Import and use**

```dart
MyCustomWidget(
  title: 'Click me',
  onTap: () => print('Tapped!'),
)
```

### Adding Quiz Question Types

1. **Add enum value** to `QuestionType`

```dart
// lib/models/quiz_question.dart
enum QuestionType {
  charToRomaji,
  romajiToChar,
  // ... existing types
  myNewQuestionType,  // ADD THIS
}
```

2. **Update quiz generator**

```dart
// lib/utils/quiz_generator.dart
static QuizQuestion _generateMyNewQuestionType(
  KanjiCharacter correct,
  List<KanjiCharacter> allKanji,
) {
  // Implementation here
  return QuizQuestion(...);
}
```

3. **Add to switch statement**

```dart
switch (questionType) {
  // ... existing cases
  case QuestionType.myNewQuestionType:
    return _generateMyNewQuestionType(kanji, characters);
}
```

## 🎨 Code Style

### Naming Conventions

- **Classes**: `PascalCase` (e.g., `KanaCharacter`)
- **Files**: `snake_case` (e.g., `kana_character.dart`)
- **Variables**: `camelCase` (e.g., `userName`)
- **Constants**: `camelCase` with `const` (e.g., `const borderRadius = 12.0`)
- **Private**: prefix with `_` (e.g., `_privateMethod()`)

### Widget Best Practices

```dart
// ✅ Good: const constructors for better performance
const Text('Hello');

// ❌ Bad: non-const when it could be
Text('Hello');

// ✅ Good: Extract widgets for readability
Widget _buildHeader() => Text('Header');

// ✅ Good: Use Key parameter
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
}
```

### File Organization

```dart
// 1. Imports (alphabetically)
import 'package:flutter/material.dart';
import '../models/my_model.dart';
import '../utils/constants.dart';

// 2. Main class
class MyScreen extends StatelessWidget {
  // 3. Constructor
  const MyScreen({Key? key}) : super(key: key);
  
  // 4. Build method
  @override
  Widget build(BuildContext context) {
    return ...;
  }
  
  // 5. Private helper methods
  Widget _buildSection() => ...;
}
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/models/kana_character_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Unit Tests

```dart
// test/models/kana_character_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_kana/models/kana_character.dart';

void main() {
  group('KanaCharacter', () {
    test('should create character correctly', () {
      const char = KanaCharacter(
        character: 'あ',
        romaji: 'a',
        type: KanaType.hiragana,
      );
      
      expect(char.character, 'あ');
      expect(char.romaji, 'a');
      expect(char.type, KanaType.hiragana);
    });
  });
}
```

### Writing Widget Tests

```dart
// test/widgets/my_widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_kana/widgets/my_widget.dart';

void main() {
  testWidgets('MyWidget displays text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyWidget(title: 'Test'),
      ),
    );
    
    expect(find.text('Test'), findsOneWidget);
  });
}
```

## ⚡ Performance

### Optimization Tips

1. **Use const constructors**
   ```dart
   const Text('Static text')  // Better performance
   ```

2. **ListView.builder for large lists**
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   ```

3. **Avoid rebuilding expensive widgets**
   ```dart
   // Use keys to preserve state
   ListView(
     children: items.map((item) => 
       ItemWidget(key: ValueKey(item.id), item: item)
     ).toList(),
   )
   ```

4. **Profile your app**
   ```bash
   flutter run --profile
   # Press 'P' for performance overlay
   ```

### Memory Management

- Large datasets (2,140 kanji): Consider lazy loading
- Use `ListView.builder` instead of `ListView`
- Clear image caches when not needed
- Profile memory usage: DevTools > Memory tab

## 🐛 Debugging

### Common Issues

**Issue: Hot reload not working**
- Solution: Hot restart with `R`

**Issue: Provider not updating UI**
- Check: Did you call `notifyListeners()`?
- Check: Are you using `Consumer` or `context.watch`?

**Issue: Data not persisting**
- Check: Did you call `StorageHelper.init()` in main()?
- Check: Are you awaiting async storage operations?

### Debug Tools

```dart
// Print debug info
debugPrint('Value: $value');

// Assert in debug mode only
assert(value != null, 'Value must not be null');

// Log in provider
print('ProgressProvider: Loading progress...');
```

### Using DevTools

```bash
# Open DevTools
flutter pub global run devtools
```

Features:
- **Inspector**: Widget tree visualization
- **Performance**: Frame rendering time
- **Memory**: Heap snapshots
- **Network**: HTTP requests
- **Logging**: Console output

## 📝 Commit Guidelines

Format: `type(scope): message`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting)
- `refactor`: Code refactoring
- `test`: Add tests
- `chore`: Maintenance

Examples:
```
feat(kanji): add stroke order animation
fix(quiz): correct answer validation logic
docs(readme): update installation instructions
```

## 🚀 Deployment

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Create archive in Xcode
open ios/Runner.xcworkspace
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

## 🤝 Need Help?

- Open an issue on GitHub
- Check existing issues and PRs
- Review the main README.md

---

Happy coding! 🎉
