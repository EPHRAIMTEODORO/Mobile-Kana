# 🎌 Mobile Kana - Flutter App

> A comprehensive cross-platform mobile application for learning Japanese Hiragana, Katakana, and Kanji characters.

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-2.17%2B-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Overview

Mobile Kana is a feature-rich Flutter application that helps users master the Japanese writing system. It includes:

- **92 Kana Characters**: Complete Hiragana and Katakana
- **2,140 Jōyō Kanji**: Organized by Japanese school grade levels (Grade 1-6 + Junior High)
- **Interactive Learning**: Flashcards, quizzes, and progress tracking
- **Offline-First**: Works completely offline
- **Cross-Platform**: iOS and Android support

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/EPHRAIMTEODORO/Mobile-Kana.git
cd Mobile-Kana

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📖 Documentation

For detailed documentation, see [README_MOBILE.md](README_MOBILE.md)

## ✨ Features

### Learning Modes
- **Kana Chart**: Visual reference grid for all characters
- **Kanji Browser**: Browse kanji by grade with detailed information
- **Flashcards**: Flip-card learning with swipe gestures
- **Quiz Mode**: Multiple-choice quizzes with various question types
- **Progress Tracking**: Detailed statistics and mastery tracking

### Kanji Features
Each kanji includes:
- English meanings
- On'yomi (音読み) and Kun'yomi (訓読み) readings
- Example words with readings and translations
- Stroke count and JLPT level
- Search and filter capabilities

## 🏗️ Architecture

This app follows clean architecture principles with:
- **Provider** for state management
- **Shared Preferences** for local storage
- **Material Design 3** UI components
- **Modular structure** with clear separation of concerns

## 📦 Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 2.17+
- **State Management**: Provider
- **Local Storage**: SharedPreferences & SQLite
- **UI**: Material Design 3

## 🎯 Current Status

✅ **Completed:**
- Project structure and core architecture
- All data models and state management
- Complete Kana dataset (92 characters)
- Sample Kanji dataset (representative samples)
- Utility functions and helpers
- Home screen and navigation

🚧 **In Progress:**
- Full screen implementations
- Widget components
- Animations and transitions

📋 **Planned:**
- Complete kanji dataset
- Spaced repetition algorithm
- Audio pronunciation
- Stroke order animations
- Cloud sync

## 🤝 Contributing

Contributions are welcome! See the detailed documentation for areas where help is needed.

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

Based on the web app: https://learn-kana-livid.vercel.app

---

Made with ❤️ using Flutter