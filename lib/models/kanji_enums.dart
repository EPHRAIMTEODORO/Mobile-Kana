enum KanjiGrade {
  grade1, // 80 kanji
  grade2, // 160 kanji
  grade3, // 200 kanji
  grade4, // 200 kanji
  grade5, // 185 kanji
  grade6, // 181 kanji
  juniorHigh // 1,134 kanji
}

enum JlptLevel { n5, n4, n3, n2, n1 }

extension KanjiGradeExtension on KanjiGrade {
  String get displayName {
    switch (this) {
      case KanjiGrade.grade1:
        return 'Grade 1';
      case KanjiGrade.grade2:
        return 'Grade 2';
      case KanjiGrade.grade3:
        return 'Grade 3';
      case KanjiGrade.grade4:
        return 'Grade 4';
      case KanjiGrade.grade5:
        return 'Grade 5';
      case KanjiGrade.grade6:
        return 'Grade 6';
      case KanjiGrade.juniorHigh:
        return 'Junior High';
    }
  }

  String get japaneseName {
    switch (this) {
      case KanjiGrade.grade1:
        return '第一学年';
      case KanjiGrade.grade2:
        return '第二学年';
      case KanjiGrade.grade3:
        return '第三学年';
      case KanjiGrade.grade4:
        return '第四学年';
      case KanjiGrade.grade5:
        return '第五学年';
      case KanjiGrade.grade6:
        return '第六学年';
      case KanjiGrade.juniorHigh:
        return '中学校';
    }
  }

  int get kanjiCount {
    switch (this) {
      case KanjiGrade.grade1:
        return 80;
      case KanjiGrade.grade2:
        return 160;
      case KanjiGrade.grade3:
        return 200;
      case KanjiGrade.grade4:
        return 200;
      case KanjiGrade.grade5:
        return 185;
      case KanjiGrade.grade6:
        return 181;
      case KanjiGrade.juniorHigh:
        return 1134;
    }
  }
}

extension JlptLevelExtension on JlptLevel {
  String get displayName {
    switch (this) {
      case JlptLevel.n5:
        return 'N5';
      case JlptLevel.n4:
        return 'N4';
      case JlptLevel.n3:
        return 'N3';
      case JlptLevel.n2:
        return 'N2';
      case JlptLevel.n1:
        return 'N1';
    }
  }
}
