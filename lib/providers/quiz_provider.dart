import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/kana_character.dart';
import '../models/kanji_character.dart';
import '../models/kanji_enums.dart';
import '../data/all_data.dart';
import '../utils/quiz_generator.dart';

class QuizProvider with ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  bool _isQuizActive = false;
  bool _isQuizCompleted = false;
  
  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  QuizQuestion? get currentQuestion =>
      _questions.isEmpty ? null : _questions[_currentQuestionIndex];
  Map<int, String> get userAnswers => _userAnswers;
  bool get isQuizActive => _isQuizActive;
  bool get isQuizCompleted => _isQuizCompleted;
  int get totalQuestions => _questions.length;
  int get correctAnswers => _calculateCorrectAnswers();
  
  double get score {
    if (_questions.isEmpty) return 0.0;
    return correctAnswers / totalQuestions;
  }
  
  void startKanaQuiz({
    required KanaType type,
    required QuestionType questionType,
    int questionCount = 10,
  }) {
    List<KanaCharacter> characters;
    
    switch (type) {
      case KanaType.hiragana:
        characters = AllData.hiragana;
        break;
      case KanaType.katakana:
        characters = AllData.katakana;
        break;
    }
    
    _questions = QuizGenerator.generateKanaQuiz(
      characters: characters,
      questionType: questionType,
      questionCount: questionCount,
    );
    
    _resetQuiz();
  }
  
  void startMixedKanaQuiz({
    required QuestionType questionType,
    int questionCount = 10,
  }) {
    final allKana = [...AllData.hiragana, ...AllData.katakana];
    
    _questions = QuizGenerator.generateKanaQuiz(
      characters: allKana,
      questionType: questionType,
      questionCount: questionCount,
    );
    
    _resetQuiz();
  }
  
  void startKanjiQuiz({
    required KanjiGrade grade,
    required QuestionType questionType,
    int questionCount = 10,
  }) {
    final kanji = AllData.getKanjiByGrade(grade);
    
    if (kanji.isEmpty) {
      return;
    }
    
    _questions = QuizGenerator.generateKanjiQuiz(
      characters: kanji,
      questionType: questionType,
      questionCount: questionCount.clamp(1, kanji.length),
    );
    
    _resetQuiz();
  }
  
  void _resetQuiz() {
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _isQuizActive = true;
    _isQuizCompleted = false;
    notifyListeners();
  }
  
  void answerQuestion(String answer) {
    if (!_isQuizActive || _isQuizCompleted) return;
    
    _userAnswers[_currentQuestionIndex] = answer;
    notifyListeners();
  }
  
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      _completeQuiz();
    }
  }
  
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }
  
  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }
  
  void _completeQuiz() {
    _isQuizCompleted = true;
    _isQuizActive = false;
    notifyListeners();
  }
  
  bool isAnswerCorrect(int questionIndex) {
    if (!_userAnswers.containsKey(questionIndex)) return false;
    
    return _userAnswers[questionIndex] ==
        _questions[questionIndex].correctAnswer;
  }
  
  int _calculateCorrectAnswers() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (isAnswerCorrect(i)) {
        correct++;
      }
    }
    return correct;
  }
  
  List<QuizQuestion> getIncorrectQuestions() {
    return _questions.asMap().entries.where((entry) {
      final index = entry.key;
      return _userAnswers.containsKey(index) && !isAnswerCorrect(index);
    }).map((entry) => entry.value).toList();
  }
  
  void retryQuiz() {
    _resetQuiz();
  }
  
  void endQuiz() {
    _questions = [];
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _isQuizActive = false;
    _isQuizCompleted = false;
    notifyListeners();
  }
}
