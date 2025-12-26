import 'dart:math';
import '../models/quiz_question.dart';
import '../models/kana_character.dart';
import '../models/kanji_character.dart';

class QuizGenerator {
  static final Random _random = Random();
  
  /// Generate quiz for Kana
  static List<QuizQuestion> generateKanaQuiz({
    required List<KanaCharacter> characters,
    required QuestionType questionType,
    int questionCount = 10,
  }) {
    final shuffled = List<KanaCharacter>.from(characters)..shuffle(_random);
    final selected = shuffled.take(questionCount).toList();
    
    return selected.map((char) {
      final options = _generateKanaOptions(char, characters, questionType);
      
      final question = questionType == QuestionType.charToRomaji
          ? char.character
          : char.romaji;
      
      final correctAnswer = questionType == QuestionType.charToRomaji
          ? char.romaji
          : char.character;
      
      return QuizQuestion(
        question: question,
        correctAnswer: correctAnswer,
        options: options,
        type: char.type == KanaType.hiragana
            ? CharacterType.hiragana
            : CharacterType.katakana,
        questionType: questionType,
      );
    }).toList()
      ..shuffle(_random);
  }
  
  static List<String> _generateKanaOptions(
    KanaCharacter correct,
    List<KanaCharacter> allChars,
    QuestionType questionType,
  ) {
    final sameType = allChars.where((c) => c.type == correct.type).toList();
    final others = List<KanaCharacter>.from(sameType)
      ..remove(correct)
      ..shuffle(_random);
    
    final incorrectOptions = others.take(3).toList();
    final options = [correct, ...incorrectOptions];
    
    final stringOptions = options.map((char) {
      return questionType == QuestionType.charToRomaji
          ? char.romaji
          : char.character;
    }).toList()
      ..shuffle(_random);
    
    return stringOptions;
  }
  
  /// Generate quiz for Kanji
  static List<QuizQuestion> generateKanjiQuiz({
    required List<KanjiCharacter> characters,
    required QuestionType questionType,
    int questionCount = 10,
  }) {
    final shuffled = List<KanjiCharacter>.from(characters)..shuffle(_random);
    final selected = shuffled.take(questionCount).toList();
    
    return selected.map((kanji) {
      switch (questionType) {
        case QuestionType.kanjiToMeaning:
          return _generateKanjiToMeaning(kanji, characters);
        case QuestionType.meaningToKanji:
          return _generateMeaningToKanji(kanji, characters);
        case QuestionType.kanjiToReading:
          return _generateKanjiToReading(kanji, characters);
        case QuestionType.readingToKanji:
          return _generateReadingToKanji(kanji, characters);
        default:
          throw ArgumentError('Invalid question type for kanji');
      }
    }).toList()
      ..shuffle(_random);
  }
  
  static QuizQuestion _generateKanjiToMeaning(
    KanjiCharacter correct,
    List<KanjiCharacter> allKanji,
  ) {
    final correctMeaning = correct.meanings.first;
    final options = _getKanjiOptions(
      correct,
      allKanji,
      (k) => k.meanings.first,
    );
    
    return QuizQuestion(
      question: correct.character,
      correctAnswer: correctMeaning,
      options: options,
      type: CharacterType.kanji,
      questionType: QuestionType.kanjiToMeaning,
    );
  }
  
  static QuizQuestion _generateMeaningToKanji(
    KanjiCharacter correct,
    List<KanjiCharacter> allKanji,
  ) {
    final meaning = correct.meanings.first;
    final options = _getKanjiOptions(
      correct,
      allKanji,
      (k) => k.character,
    );
    
    return QuizQuestion(
      question: meaning,
      correctAnswer: correct.character,
      options: options,
      type: CharacterType.kanji,
      questionType: QuestionType.meaningToKanji,
    );
  }
  
  static QuizQuestion _generateKanjiToReading(
    KanjiCharacter correct,
    List<KanjiCharacter> allKanji,
  ) {
    // Randomly choose between onyomi and kunyomi
    final useOnyomi = _random.nextBool() || correct.kunyomi.isEmpty;
    final correctReading = useOnyomi && correct.onyomi.isNotEmpty
        ? correct.onyomi.first
        : correct.kunyomi.isNotEmpty
            ? correct.kunyomi.first
            : correct.onyomi.first;
    
    final options = _getKanjiOptions(
      correct,
      allKanji,
      (k) {
        if (useOnyomi && k.onyomi.isNotEmpty) return k.onyomi.first;
        if (k.kunyomi.isNotEmpty) return k.kunyomi.first;
        return k.onyomi.isNotEmpty ? k.onyomi.first : 'N/A';
      },
    );
    
    return QuizQuestion(
      question: correct.character,
      correctAnswer: correctReading,
      options: options,
      type: CharacterType.kanji,
      questionType: QuestionType.kanjiToReading,
      additionalInfo: useOnyomi ? 'On\'yomi' : 'Kun\'yomi',
    );
  }
  
  static QuizQuestion _generateReadingToKanji(
    KanjiCharacter correct,
    List<KanjiCharacter> allKanji,
  ) {
    final useOnyomi = _random.nextBool() || correct.kunyomi.isEmpty;
    final reading = useOnyomi && correct.onyomi.isNotEmpty
        ? correct.onyomi.first
        : correct.kunyomi.isNotEmpty
            ? correct.kunyomi.first
            : correct.onyomi.first;
    
    final options = _getKanjiOptions(
      correct,
      allKanji,
      (k) => k.character,
    );
    
    return QuizQuestion(
      question: reading,
      correctAnswer: correct.character,
      options: options,
      type: CharacterType.kanji,
      questionType: QuestionType.readingToKanji,
      additionalInfo: useOnyomi ? 'On\'yomi' : 'Kun\'yomi',
    );
  }
  
  static List<String> _getKanjiOptions(
    KanjiCharacter correct,
    List<KanjiCharacter> allKanji,
    String Function(KanjiCharacter) selector,
  ) {
    final others = List<KanjiCharacter>.from(allKanji)
      ..remove(correct)
      ..shuffle(_random);
    
    final incorrectOptions = others.take(3).map(selector).toList();
    final options = [selector(correct), ...incorrectOptions]..shuffle(_random);
    
    return options;
  }
}
