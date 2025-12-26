enum CharacterType { hiragana, katakana, kanji }

enum QuestionType {
  charToRomaji,
  romajiToChar,
  kanjiToMeaning,
  meaningToKanji,
  kanjiToReading,
  readingToKanji
}

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> options;
  final CharacterType type;
  final QuestionType questionType;
  final String? additionalInfo;

  const QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.type,
    required this.questionType,
    this.additionalInfo,
  });

  String get questionTypeDisplay {
    switch (questionType) {
      case QuestionType.charToRomaji:
        return 'Character to Romaji';
      case QuestionType.romajiToChar:
        return 'Romaji to Character';
      case QuestionType.kanjiToMeaning:
        return 'Kanji to Meaning';
      case QuestionType.meaningToKanji:
        return 'Meaning to Kanji';
      case QuestionType.kanjiToReading:
        return 'Kanji to Reading';
      case QuestionType.readingToKanji:
        return 'Reading to Kanji';
    }
  }
}
