import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_progress.dart';

class StorageHelper {
  static const String _progressKey = 'character_progress';
  static const String _themeKey = 'theme_mode';
  static const String _streakKey = 'daily_streak';
  static const String _lastPracticeKey = 'last_practice_date';
  
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Progress Storage
  static Future<void> saveProgress(List<CharacterProgress> progressList) async {
    if (_prefs == null) await init();
    
    final jsonList = progressList.map((p) => p.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _prefs!.setString(_progressKey, jsonString);
  }
  
  static Future<List<CharacterProgress>> loadProgress() async {
    if (_prefs == null) await init();
    
    final jsonString = _prefs!.getString(_progressKey);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => CharacterProgress.fromJson(json as Map<String, dynamic>))
        .toList();
  }
  
  static Future<void> updateCharacterProgress(
    String character,
    bool correct,
  ) async {
    final progressList = await loadProgress();
    
    final index = progressList.indexWhere((p) => p.character == character);
    
    if (index >= 0) {
      if (correct) {
        progressList[index].correct++;
      } else {
        progressList[index].incorrect++;
      }
      progressList[index].lastReviewed = DateTime.now();
    } else {
      progressList.add(CharacterProgress(
        character: character,
        correct: correct ? 1 : 0,
        incorrect: correct ? 0 : 1,
        lastReviewed: DateTime.now(),
      ));
    }
    
    await saveProgress(progressList);
  }
  
  static Future<CharacterProgress?> getCharacterProgress(String character) async {
    final progressList = await loadProgress();
    try {
      return progressList.firstWhere((p) => p.character == character);
    } catch (e) {
      return null;
    }
  }
  
  // Theme Storage
  static Future<void> saveThemeMode(bool isDark) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_themeKey, isDark);
  }
  
  static Future<bool> getThemeMode() async {
    if (_prefs == null) await init();
    return _prefs!.getBool(_themeKey) ?? false;
  }
  
  // Streak Storage
  static Future<void> updateStreak() async {
    if (_prefs == null) await init();
    
    final lastPractice = _prefs!.getString(_lastPracticeKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastPractice == null) {
      // First time practicing
      await _prefs!.setInt(_streakKey, 1);
      await _prefs!.setString(_lastPracticeKey, today.toIso8601String());
    } else {
      final lastDate = DateTime.parse(lastPractice);
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = today.difference(lastDay).inDays;
      
      if (diff == 0) {
        // Already practiced today, do nothing
        return;
      } else if (diff == 1) {
        // Consecutive day
        final currentStreak = _prefs!.getInt(_streakKey) ?? 0;
        await _prefs!.setInt(_streakKey, currentStreak + 1);
        await _prefs!.setString(_lastPracticeKey, today.toIso8601String());
      } else {
        // Streak broken
        await _prefs!.setInt(_streakKey, 1);
        await _prefs!.setString(_lastPracticeKey, today.toIso8601String());
      }
    }
  }
  
  static Future<int> getStreak() async {
    if (_prefs == null) await init();
    return _prefs!.getInt(_streakKey) ?? 0;
  }
  
  // Clear all data
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}
