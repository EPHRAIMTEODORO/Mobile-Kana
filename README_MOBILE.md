# 🎌 Mobile Kana - Learn Japanese Characters

A comprehensive Flutter mobile application for learning Japanese Hiragana, Katakana, and Kanji characters. This app provides an interactive and engaging way to master all three Japanese writing systems with 92 Kana characters and 2,140 Jōyō Kanji.

## ✨ Features

### 📱 Core Features
- **Kana Chart**: Complete visual reference for all 92 Hiragana and Katakana characters
- **Kanji Browser**: Browse 2,140 Jōyō Kanji organized by grade (Grade 1-6 + Junior High)
- **Flashcards**: Interactive flip-card learning mode for Kana and Kanji
- **Quiz Mode**: Multiple-choice quizzes with various question types
- **Progress Tracking**: Detailed statistics and mastery tracking for each character
- **Dark Mode**: Full support for light and dark themes

### 🎯 Kanji Features
- **7 Grade Levels**: Organized by Japanese school curriculum
  - Grade 1: 80 kanji
  - Grade 2: 160 kanji
  - Grade 3: 200 kanji
  - Grade 4: 202 kanji
  - Grade 5: 193 kanji
  - Grade 6: 191 kanji
  - Junior High: 1,126 kanji
- **Comprehensive Details**: Each kanji includes:
  - Multiple meanings in English
  - On'yomi (音読み) readings in katakana
  - Kun'yomi (訓読み) readings in hiragana
  - Example words with readings and meanings
  - Stroke count
  - JLPT level
  - Frequency ranking (when available)
- **Search & Filter**: Search by character, meaning, or reading
- **JLPT Filtering**: Filter kanji by JLPT level (N5-N1)
- **Sorting Options**: Sort by frequency or stroke count

### 📚 Quiz Types

**For Kana:**
- Character → Romaji
- Romaji → Character

**For Kanji:**
- Kanji → Meaning
- Meaning → Kanji
- Kanji → Reading (On'yomi or Kun'yomi)
- Reading → Kanji

### 📊 Progress Tracking
- Per-character statistics (correct/incorrect attempts)
- Accuracy percentage
- Mastery status (≥80% accuracy)
- Daily practice streak
- Overall statistics and visualizations
- Separate tracking for Kana and Kanji

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/EPHRAIMTEODORO/Mobile-Kana.git
cd Mobile-Kana
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📂 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   ├── kana_character.dart       # Kana character model
│   ├── kanji_character.dart      # Kanji character model
│   ├── kanji_example.dart        # Kanji example model
│   ├── kanji_enums.dart          # Kanji enums (Grade, JLPT level)
│   ├── character_progress.dart   # Progress tracking model
│   └── quiz_question.dart        # Quiz question model
├── data/                          # Data files
│   ├── hiragana_data.dart        # 46 Hiragana characters
│   ├── katakana_data.dart        # 46 Katakana characters
│   ├── kanji/                    # Kanji data by grade
│   │   ├── grade1_kanji.dart
│   │   ├── grade2_kanji.dart
│   │   ├── grade3_kanji.dart
│   │   ├── grade4_kanji.dart
│   │   ├── grade5_kanji.dart
│   │   ├── grade6_kanji.dart
│   │   └── junior_high_kanji.dart
│   └── all_data.dart             # Consolidated data access
├── providers/                     # State management (Provider)
│   ├── progress_provider.dart    # Progress tracking state
│   ├── theme_provider.dart       # Theme management state
│   ├── quiz_provider.dart        # Quiz state
│   └── kanji_provider.dart       # Kanji browser state
├── screens/                       # Main screens
│   ├── home_screen.dart          # Home/landing screen
│   ├── chart_screen.dart         # Kana chart reference
│   ├── kanji_browser_screen.dart # Kanji browser
│   ├── flashcard_screen.dart     # Flashcard learning
│   ├── quiz_screen.dart          # Quiz mode
│   └── progress_screen.dart      # Progress dashboard
├── widgets/                       # Reusable widgets
│   ├── flashcard_widget.dart
│   ├── kanji_flashcard_widget.dart
│   ├── kana_grid_cell.dart
│   ├── kanji_grid_cell.dart
│   ├── kanji_detail_card.dart
│   ├── quiz_question_card.dart
│   └── progress_stat_card.dart
└── utils/                         # Utilities
    ├── quiz_generator.dart       # Quiz generation logic
    ├── kanji_search.dart         # Kanji search/filter
    ├── storage_helper.dart       # Local storage (SharedPreferences)
    └── constants.dart            # App constants

```

## 🎨 Design System

### Color Palette
- **Kana Colors**: Indigo gradient (#4F46E5 → #6366F1)
- **Kanji Colors**: Purple/Pink gradient (#9333EA → #EC4899)
- **On'yomi**: Red chips (#FEE2E2 bg, #991B1B text)
- **Kun'yomi**: Green chips (#D1FAE5 bg, #065F46 text)
- **Meanings**: Blue chips (#DBEAFE bg, #1E40AF text)
- **Status Colors**: Green (success), Red (error), Amber (warning)

### Typography
- **Japanese Text**: Noto Sans JP
- **Latin Text**: System default (San Francisco/Roboto)

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  shared_preferences: ^2.2.2    # Local storage
  sqflite: ^2.3.0               # Database (for complex queries)
  path_provider: ^2.1.1         # File system access
  flutter_staggered_animations: ^1.1.1  # Animations
  animations: ^2.0.8            # Page transitions
  confetti: ^0.7.0              # Celebration effects
  shimmer: ^3.0.0               # Loading states
  google_fonts: ^6.1.0          # Custom fonts
```

## 🔧 Configuration

### Theme Configuration
The app supports both light and dark themes. Theme preference is saved locally and persists between app launches.

### Data Configuration
The app currently includes sample kanji data for each grade level. For a production app with all 2,140 kanji, you'll need to:

1. **Source Complete Data**: Use datasets like KANJIDIC2, Kanji alive, or WaniKani API
2. **Update Data Files**: Populate all kanji data files with complete character sets
3. **Optimize Storage**: Consider using SQLite for better performance with large datasets

## 🚧 Current Status

### ✅ Completed
- Project structure and dependencies
- All data models (Kana, Kanji, Progress, Quiz)
- Complete Kana dataset (92 characters)
- Sample Kanji dataset (representative samples from all 7 grades)
- All providers for state management
- Utility functions (quiz generator, search, storage)
- Home screen with navigation
- Basic screen scaffolds

### 🔨 In Progress
- Full implementation of all screens
- Reusable widget components
- Animations and transitions
- Haptic feedback

### 📋 Todo
- Complete kanji dataset (currently has samples)
- Advanced filtering and sorting
- Spaced repetition algorithm
- Audio pronunciation
- Stroke order animations
- Cloud sync
- Achievements system

## 📝 Data Sources

To complete the kanji dataset, consider these sources:

1. **KANJIDIC2**: http://www.edrdg.org/wiki/index.php/KANJIDIC_Project
   - Comprehensive kanji dictionary
   - Free for non-commercial use

2. **Kanji alive**: https://github.com/kanjialive/kanji-data-media
   - Open-source kanji data with stroke orders
   - MIT License

3. **WaniKani API**: https://docs.api.wanikani.com/
   - Community-driven kanji data
   - API access available

## 🤝 Contributing

Contributions are welcome! Areas where help is needed:

1. **Complete Kanji Dataset**: Add remaining kanji for all grade levels
2. **UI Improvements**: Enhance screen designs and animations
3. **Features**: Implement advanced features like spaced repetition
4. **Testing**: Add unit and widget tests
5. **Localization**: Add support for multiple languages

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Original web app: https://learn-kana-livid.vercel.app
- Japanese writing system educators and resources
- Flutter and Dart communities
- Open-source kanji data providers

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Note**: This is a learning application intended for educational purposes. All kanji data should be verified against official sources before use in production.

🎌 **Happy Learning!** 頑張ってください！
