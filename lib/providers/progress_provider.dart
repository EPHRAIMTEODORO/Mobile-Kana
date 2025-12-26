import 'package:flutter/material.dart';
import '../models/character_progress.dart';
import '../utils/storage_helper.dart';

class ProgressProvider with ChangeNotifier {
  List<CharacterProgress> _progressList = [];
  bool _isLoading = true;
  int _currentStreak = 0;
  
  List<CharacterProgress> get progressList => _progressList;
  bool get isLoading => _isLoading;
  int get currentStreak => _currentStreak;
  
  ProgressProvider() {
    loadProgress();
  }
  
  Future<void> loadProgress() async {
    _isLoading = true;
    notifyListeners();
    
    _progressList = await StorageHelper.loadProgress();
    _currentStreak = await StorageHelper.getStreak();
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> updateProgress(String character, bool correct) async {
    await StorageHelper.updateCharacterProgress(character, correct);
    await StorageHelper.updateStreak();
    await loadProgress();
  }
  
  CharacterProgress? getProgress(String character) {
    try {
      return _progressList.firstWhere((p) => p.character == character);
    } catch (e) {
      return null;
    }
  }
  
  double getAccuracy(String character) {
    final progress = getProgress(character);
    return progress?.accuracy ?? 0.0;
  }
  
  bool isMastered(String character) {
    final progress = getProgress(character);
    return progress?.isMastered ?? false;
  }
  
  // Statistics
  int get totalPracticed => _progressList.length;
  
  double get overallAccuracy {
    if (_progressList.isEmpty) return 0.0;
    
    final totalCorrect = _progressList.fold<int>(
      0,
      (sum, p) => sum + p.correct,
    );
    final totalAttempts = _progressList.fold<int>(
      0,
      (sum, p) => sum + p.correct + p.incorrect,
    );
    
    return totalAttempts == 0 ? 0.0 : totalCorrect / totalAttempts;
  }
  
  int get masteredCount {
    return _progressList.where((p) => p.isMastered).length;
  }
  
  List<CharacterProgress> getMasteredCharacters() {
    return _progressList.where((p) => p.isMastered).toList();
  }
  
  List<CharacterProgress> getLearningCharacters() {
    return _progressList
        .where((p) => !p.isMastered && (p.correct + p.incorrect) > 0)
        .toList();
  }
  
  // Filter progress by character type
  List<CharacterProgress> filterByCharacters(List<String> characters) {
    return _progressList
        .where((p) => characters.contains(p.character))
        .toList();
  }
  
  Future<void> clearAllProgress() async {
    await StorageHelper.clearAll();
    await loadProgress();
  }
}
