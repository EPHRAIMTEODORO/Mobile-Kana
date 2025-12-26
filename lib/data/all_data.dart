import 'hiragana_data.dart';
import 'katakana_data.dart';
import 'kanji/grade1_kanji.dart';
import 'kanji/grade2_kanji.dart';
import 'kanji/grade3_kanji.dart';
import 'kanji/grade4_kanji.dart';
import 'kanji/grade5_kanji.dart';
import 'kanji/grade6_kanji.dart';
import 'kanji/junior_high_kanji.dart';
import '../models/kana_character.dart';
import '../models/kanji_character.dart';
import '../models/kanji_enums.dart';

class AllData {
  static const List<KanaCharacter> hiragana = hiraganaData;
  static const List<KanaCharacter> katakana = katakanaData;
  
  static const Map<KanjiGrade, List<KanjiCharacter>> kanjiByGrade = {
    KanjiGrade.grade1: grade1Kanji,
    KanjiGrade.grade2: grade2Kanji,
    KanjiGrade.grade3: grade3Kanji,
    KanjiGrade.grade4: grade4Kanji,
    KanjiGrade.grade5: grade5Kanji,
    KanjiGrade.grade6: grade6Kanji,
    KanjiGrade.juniorHigh: juniorHighKanji,
  };
  
  static List<KanaCharacter> get allKana => [...hiragana, ...katakana];
  
  static List<KanjiCharacter> get allKanji {
    final List<KanjiCharacter> all = [];
    kanjiByGrade.forEach((grade, kanji) {
      all.addAll(kanji);
    });
    return all;
  }
  
  static List<KanjiCharacter> getKanjiByGrade(KanjiGrade grade) {
    return kanjiByGrade[grade] ?? [];
  }
}
