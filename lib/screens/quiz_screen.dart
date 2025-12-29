import 'package:flutter/material.dart';
import '../data/hiragana_data.dart';
import '../data/katakana_data.dart';
import '../data/all_data.dart';
import '../models/quiz_question.dart';
import '../utils/quiz_generator.dart';
import '../utils/storage_helper.dart';

enum QuizMode { hiragana, katakana, mixed, kanji }

enum QuizState { setup, question, results }

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizMode _selectedMode = QuizMode.hiragana;
  QuizState _currentState = QuizState.setup;
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;

  void _startQuiz() {
    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _showFeedback = false;
      _questions = _generateQuestions();
      _currentState = QuizState.question;
    });
  }

  List<QuizQuestion> _generateQuestions() {
    switch (_selectedMode) {
      case QuizMode.hiragana:
        return QuizGenerator.generateKanaQuiz(
          characters: hiraganaData,
          questionType: QuestionType.charToRomaji,
          questionCount: 10,
        );
      case QuizMode.katakana:
        return QuizGenerator.generateKanaQuiz(
          characters: katakanaData,
          questionType: QuestionType.charToRomaji,
          questionCount: 10,
        );
      case QuizMode.mixed:
        final mixed = [...hiraganaData, ...katakanaData];
        return QuizGenerator.generateKanaQuiz(
          characters: mixed,
          questionType: QuestionType.charToRomaji,
          questionCount: 10,
        );
      case QuizMode.kanji:
        return QuizGenerator.generateKanjiQuiz(
          characters: AllData.allKanji,
          questionType: QuestionType.kanjiToMeaning,
          questionCount: 10,
        );
    }
  }

  void _selectAnswer(String answer) async {
    if (_showFeedback) return;

    setState(() {
      _selectedAnswer = answer;
      _showFeedback = true;
    });

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = answer == currentQuestion.correctAnswer;

    if (isCorrect) {
      setState(() {
        _score++;
      });
    }

    // Track progress for the character
    if (_selectedMode != QuizMode.kanji) {
      await StorageHelper.updateCharacterProgress(
        currentQuestion.question,
        isCorrect,
      );
    }

    // Wait before moving to next question
    await Future.delayed(const Duration(milliseconds: 1500));

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
      });
    } else {
      setState(() {
        _currentState = QuizState.results;
      });
    }
  }

  void _tryAgain() {
    _startQuiz();
  }

  void _changeMode() {
    setState(() {
      _currentState = QuizState.setup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Mode'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: _buildCurrentState(),
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case QuizState.setup:
        return _buildSetupScreen();
      case QuizState.question:
        return _buildQuestionScreen();
      case QuizState.results:
        return _buildResultsScreen();
    }
  }

  Widget _buildSetupScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Your Quiz Mode',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildModeButton('Hiragana Only', QuizMode.hiragana),
            const SizedBox(height: 16),
            _buildModeButton('Katakana Only', QuizMode.katakana),
            const SizedBox(height: 16),
            _buildModeButton('Mixed (Hiragana & Katakana)', QuizMode.mixed),
            const SizedBox(height: 16),
            _buildModeButton('Kanji (All Grades)', QuizMode.kanji),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Quiz (10 Questions)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, QuizMode mode) {
    final isSelected = _selectedMode == mode;
    return InkWell(
      onTap: () => setState(() => _selectedMode = mode),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade600 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple.shade600 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      children: [
        // Progress Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white.withOpacity(0.9),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade600),
                minHeight: 8,
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getQuestionText(currentQuestion),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildAnswerOptions(currentQuestion),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getQuestionText(QuizQuestion question) {
    if (_selectedMode == QuizMode.kanji) {
      switch (question.questionType) {
        case QuestionType.kanjiToMeaning:
          return 'What is the meaning of this kanji?';
        case QuestionType.meaningToKanji:
          return 'Which kanji means this?';
        case QuestionType.kanjiToReading:
          return 'What is the reading of this kanji?';
        default:
          return 'What is the answer?';
      }
    } else {
      return question.questionType == QuestionType.charToRomaji
          ? 'What is the romaji for this character?'
          : 'What is the character for this romaji?';
    }
  }

  Widget _buildAnswerOptions(QuizQuestion question) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: question.options.map((option) {
        return _buildAnswerButton(option, question.correctAnswer);
      }).toList(),
    );
  }

  Widget _buildAnswerButton(String option, String correctAnswer) {
    Color backgroundColor;
    Color textColor = Colors.black87;
    bool isDisabled = false;

    if (_showFeedback) {
      isDisabled = true;
      if (option == correctAnswer) {
        backgroundColor = Colors.green.shade500;
        textColor = Colors.white;
      } else if (option == _selectedAnswer) {
        backgroundColor = Colors.red.shade500;
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.grey.shade200;
      }
    } else {
      backgroundColor = Colors.grey.shade100;
    }

    return ElevatedButton(
      onPressed: isDisabled ? null : () => _selectAnswer(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        disabledBackgroundColor: backgroundColor,
        disabledForegroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: _showFeedback ? 2 : 4,
      ),
      child: Text(
        option,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).round();
    String message;
    String emoji;

    if (_score == _questions.length) {
      message = 'Perfect score!';
      emoji = '🎉';
    } else if (percentage >= 70) {
      message = 'Great job!';
      emoji = '👏';
    } else {
      message = 'Keep practicing!';
      emoji = '💪';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz Complete!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              '$_score / ${_questions.length}',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$message $emoji',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _tryAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _changeMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Change Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
