import 'package:flutter/material.dart';

// App Colors
class AppColors {
  // Kana Colors
  static const kanaGradientStart = Color(0xFF4F46E5); // Indigo
  static const kanaGradientEnd = Color(0xFF6366F1); // Light Indigo
  
  // Kanji Colors
  static const kanjiGradientStart = Color(0xFF9333EA); // Purple
  static const kanjiGradientEnd = Color(0xFFEC4899); // Pink
  
  // Status Colors
  static const success = Color(0xFF10B981); // Green
  static const error = Color(0xFFEF4444); // Red
  static const warning = Color(0xFFF59E0B); // Amber
  static const info = Color(0xFF3B82F6); // Blue
  
  // Reading Type Colors (Light Mode)
  static const onyomiBackground = Color(0xFFFEE2E2); // Light Red
  static const onyomiText = Color(0xFF991B1B); // Dark Red
  
  static const kunyomiBackground = Color(0xFFD1FAE5); // Light Green
  static const kunyomiText = Color(0xFF065F46); // Dark Green
  
  static const meaningBackground = Color(0xFFDBEAFE); // Light Blue
  static const meaningText = Color(0xFF1E40AF); // Dark Blue
  
  // Grays
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);
}

// Text Styles
class AppTextStyles {
  static const displayLarge = TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  );
  
  static const displayMedium = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  );
  
  static const displaySmall = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w400,
  );
  
  static const headlineLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  
  static const headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  
  static const titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
}

// Constants
class AppConstants {
  static const String appName = 'Learn Kana';
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Quiz Settings
  static const int defaultQuizQuestionCount = 10;
  static const int quizOptionCount = 4;
  
  // Progress Thresholds
  static const double masteryThreshold = 0.8;
  static const int minAttemptsForMastery = 5;
}

// Route Names
class AppRoutes {
  static const String home = '/';
  static const String chart = '/chart';
  static const String kanjiBrowser = '/kanji-browser';
  static const String flashcards = '/flashcards';
  static const String quiz = '/quiz';
  static const String progress = '/progress';
}
