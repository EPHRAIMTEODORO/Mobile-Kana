import 'kanji_enums.dart';
import 'kanji_example.dart';

class KanjiCharacter {
  final String character;
  final List<String> meanings;
  final List<String> onyomi;
  final List<String> kunyomi;
  final List<KanjiExample> examples;
  final KanjiGrade grade;
  final int? strokeCount;
  final JlptLevel? jlptLevel;
  final int? frequency;
  final List<String>? radicals;
  final String? mnemonics;

  const KanjiCharacter({
    required this.character,
    required this.meanings,
    required this.onyomi,
    required this.kunyomi,
    required this.examples,
    required this.grade,
    this.strokeCount,
    this.jlptLevel,
    this.frequency,
    this.radicals,
    this.mnemonics,
  });

  Map<String, dynamic> toJson() => {
        'character': character,
        'meanings': meanings,
        'onyomi': onyomi,
        'kunyomi': kunyomi,
        'examples': examples.map((e) => e.toJson()).toList(),
        'grade': grade.toString(),
        if (strokeCount != null) 'strokeCount': strokeCount,
        if (jlptLevel != null) 'jlptLevel': jlptLevel.toString(),
        if (frequency != null) 'frequency': frequency,
        if (radicals != null) 'radicals': radicals,
        if (mnemonics != null) 'mnemonics': mnemonics,
      };

  factory KanjiCharacter.fromJson(Map<String, dynamic> json) {
    return KanjiCharacter(
      character: json['character'] as String,
      meanings: List<String>.from(json['meanings'] as List),
      onyomi: List<String>.from(json['onyomi'] as List),
      kunyomi: List<String>.from(json['kunyomi'] as List),
      examples: (json['examples'] as List)
          .map((e) => KanjiExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      grade: _parseKanjiGrade(json['grade'] as String),
      strokeCount: json['strokeCount'] as int?,
      jlptLevel: json['jlptLevel'] != null
          ? _parseJlptLevel(json['jlptLevel'] as String)
          : null,
      frequency: json['frequency'] as int?,
      radicals: json['radicals'] != null
          ? List<String>.from(json['radicals'] as List)
          : null,
      mnemonics: json['mnemonics'] as String?,
    );
  }

  static KanjiGrade _parseKanjiGrade(String grade) {
    switch (grade) {
      case 'KanjiGrade.grade1':
      case 'grade1':
        return KanjiGrade.grade1;
      case 'KanjiGrade.grade2':
      case 'grade2':
        return KanjiGrade.grade2;
      case 'KanjiGrade.grade3':
      case 'grade3':
        return KanjiGrade.grade3;
      case 'KanjiGrade.grade4':
      case 'grade4':
        return KanjiGrade.grade4;
      case 'KanjiGrade.grade5':
      case 'grade5':
        return KanjiGrade.grade5;
      case 'KanjiGrade.grade6':
      case 'grade6':
        return KanjiGrade.grade6;
      default:
        return KanjiGrade.juniorHigh;
    }
  }

  static JlptLevel _parseJlptLevel(String level) {
    switch (level) {
      case 'JlptLevel.n5':
      case 'n5':
      case 'N5':
        return JlptLevel.n5;
      case 'JlptLevel.n4':
      case 'n4':
      case 'N4':
        return JlptLevel.n4;
      case 'JlptLevel.n3':
      case 'n3':
      case 'N3':
        return JlptLevel.n3;
      case 'JlptLevel.n2':
      case 'n2':
      case 'N2':
        return JlptLevel.n2;
      default:
        return JlptLevel.n1;
    }
  }
}
