# 🚀 Quick Start Guide

Get the Mobile Kana app running in 5 minutes!

## Prerequisites Check

```bash
# Check Flutter installation
flutter doctor

# Expected output: ✓ for Flutter, Dart, and at least one platform (Android/iOS)
```

## Installation

### 1. Clone & Navigate
```bash
git clone https://github.com/EPHRAIMTEODORO/Mobile-Kana.git
cd Mobile-Kana
```

### 2. Install Dependencies
```bash
flutter pub get
```

Expected output:
```
Running "flutter pub get" in Mobile-Kana...
✓ All dependencies installed successfully!
```

### 3. Verify Setup
```bash
flutter analyze
```

Should show no errors.

## Running the App

### Option 1: Using VS Code
1. Open the project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select your target device from the status bar

### Option 2: Using Command Line

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Or just run on first available device
flutter run
```

### Option 3: Using Android Studio
1. Open the project in Android Studio
2. Select target device from dropdown
3. Click the green play button ▶️

## What You'll See

1. **Home Screen** with 5 navigation cards:
   - 📋 Kana Chart
   - 漢 Kanji
   - 🎴 Flashcards
   - ✍️ Quiz Mode
   - 📊 Progress

2. Currently, clicking cards navigates to placeholder screens (implementation in progress)

3. The **Home Screen is fully functional** with:
   - Beautiful gradient background
   - Animated Japanese characters
   - Smooth navigation
   - Theme support (light/dark)

## Testing Features

### Test Data Access
The app includes:
- ✅ **92 Kana characters** (46 Hiragana + 46 Katakana)
- ✅ **~80 sample Kanji** from all grade levels
- ✅ All with proper readings, meanings, and examples

### Test Providers
Open Flutter DevTools to inspect:
- ThemeProvider (toggle theme)
- ProgressProvider (tracks learning)
- KanjiProvider (manages kanji state)
- QuizProvider (quiz sessions)

### Test Storage
Progress is automatically saved to device storage using SharedPreferences.

## Development Mode

### Hot Reload
While app is running:
- Press `r` → Hot reload (fast, preserves state)
- Press `R` → Hot restart (slower, resets state)
- Press `p` → Show performance overlay
- Press `o` → Toggle platform (Android/iOS)

### Debug Output
Check your terminal/console for debug messages:
```
flutter: ThemeProvider: Loading theme...
flutter: ProgressProvider: Progress loaded
flutter: KanjiProvider: Selected Grade 1
```

## Common Issues & Solutions

### Issue: "Unable to locate Android SDK"
**Solution:**
```bash
# Set Android SDK path
export ANDROID_HOME=$HOME/Android/Sdk
# Or set in Android Studio > Preferences > System Settings > Android SDK
```

### Issue: "No devices found"
**Solution:**
```bash
# For Android emulator
flutter emulators
flutter emulators --launch <emulator_id>

# For iOS simulator (macOS only)
open -a Simulator
```

### Issue: "Version solving failed"
**Solution:**
```bash
flutter pub upgrade
flutter clean
flutter pub get
```

### Issue: "CocoaPods not installed" (iOS)
**Solution:**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

## Building for Release

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)
```bash
flutter build ios --release
# Then open Xcode to create archive
```

## Project Structure Overview

```
lib/
├── main.dart              ← START HERE
├── models/                ← Data structures
├── data/                  ← Kana and Kanji datasets
├── providers/             ← State management
├── screens/               ← App screens
├── widgets/               ← Reusable components (TODO)
└── utils/                 ← Helper functions
```

## Next Steps

1. ✅ **Run the app** - See the home screen
2. 📖 **Read [README_MOBILE.md](README_MOBILE.md)** - Understand features
3. 🛠️ **Read [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)** - Learn architecture
4. 🎨 **Implement screens** - Start with Kana Chart or Kanji Browser
5. 🧩 **Create widgets** - Build reusable components
6. ✨ **Add animations** - Polish the UI

## Useful Commands

```bash
# Format code
flutter format lib/

# Analyze code
flutter analyze

# Run tests (when added)
flutter test

# Clean build files
flutter clean

# Update dependencies
flutter pub upgrade

# Generate app icons (after setup)
flutter pub run flutter_launcher_icons:main

# Check outdated packages
flutter pub outdated
```

## Need Help?

1. 📋 Check [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for what's implemented
2. 🐛 Check [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) for debugging tips
3. 💬 Open an issue on GitHub
4. 📧 Contact the maintainers

## Performance Tips

- Use **release mode** for testing actual performance:
  ```bash
  flutter run --release
  ```
  
- Enable **performance overlay**:
  ```bash
  flutter run --profile
  # Then press 'P' in terminal
  ```

- Use **DevTools** for debugging:
  ```bash
  flutter pub global run devtools
  ```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)
- [Provider Package](https://pub.dev/packages/provider)

---

**You're all set! Happy coding! 🎉**

For detailed information, see:
- [README.md](README.md) - Project overview
- [README_MOBILE.md](README_MOBILE.md) - Feature documentation  
- [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) - Development guide
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Implementation status
