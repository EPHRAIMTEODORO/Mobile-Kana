import '../models/kanji_character.dart';
import '../models/kanji_example.dart';
import '../models/kanji_enums.dart';

// Junior High: 1,126 kanji (sample of 15 shown)
// This represents the remaining Jōyō kanji learned in junior high school
const List<KanjiCharacter> juniorHighKanji = [
  KanjiCharacter(
    character: '亜',
    meanings: ['Asia', 'rank next', 'come after', 'sub-'],
    onyomi: ['ア'],
    kunyomi: [],
    examples: [
      KanjiExample(word: '亜鉛', reading: 'あえん', meaning: 'zinc'),
      KanjiExample(word: 'アジア', reading: 'あじあ', meaning: 'Asia'),
      KanjiExample(word: '亜熱帯', reading: 'あねったい', meaning: 'subtropics'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 7,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '哀',
    meanings: ['pathetic', 'grief', 'sorrow'],
    onyomi: ['アイ'],
    kunyomi: ['あわ.れ', 'あわ.れむ'],
    examples: [
      KanjiExample(word: '哀れ', reading: 'あわれ', meaning: 'pity, pathos'),
      KanjiExample(word: '悲哀', reading: 'ひあい', meaning: 'sorrow, grief'),
      KanjiExample(word: '哀悼', reading: 'あいとう', meaning: 'condolence, mourning'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 9,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '挨',
    meanings: ['approach', 'draw near', 'push open'],
    onyomi: ['アイ'],
    kunyomi: [],
    examples: [
      KanjiExample(word: '挨拶', reading: 'あいさつ', meaning: 'greeting'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 10,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '曖',
    meanings: ['dark', 'obscure', 'unclear'],
    onyomi: ['アイ'],
    kunyomi: [],
    examples: [
      KanjiExample(word: '曖昧', reading: 'あいまい', meaning: 'ambiguous, vague'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 17,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '握',
    meanings: ['grip', 'hold', 'grasp'],
    onyomi: ['アク'],
    kunyomi: ['にぎ.る'],
    examples: [
      KanjiExample(word: '握る', reading: 'にぎる', meaning: 'to grasp, grip'),
      KanjiExample(word: '握手', reading: 'あくしゅ', meaning: 'handshake'),
      KanjiExample(word: '把握', reading: 'はあく', meaning: 'grasp, understanding'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 12,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '扱',
    meanings: ['handle', 'deal with', 'treat'],
    onyomi: ['ソウ', 'キュウ'],
    kunyomi: ['あつか.う', 'あつか.い'],
    examples: [
      KanjiExample(word: '扱う', reading: 'あつかう', meaning: 'to handle, deal with'),
      KanjiExample(word: '取扱', reading: 'とりあつかい', meaning: 'treatment, handling'),
      KanjiExample(word: '扱い方', reading: 'あつかいかた', meaning: 'way of handling'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 6,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '宛',
    meanings: ['address', 'just like', 'fortunately'],
    onyomi: ['エン'],
    kunyomi: ['あ.てる'],
    examples: [
      KanjiExample(word: '宛先', reading: 'あてさき', meaning: 'address, destination'),
      KanjiExample(word: '宛名', reading: 'あてな', meaning: 'addressee'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 8,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '嵐',
    meanings: ['storm', 'tempest'],
    onyomi: ['ラン'],
    kunyomi: ['あらし'],
    examples: [
      KanjiExample(word: '嵐', reading: 'あらし', meaning: 'storm'),
      KanjiExample(word: '暴風雨', reading: 'ぼうふうう', meaning: 'storm, tempest'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 12,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '或',
    meanings: ['a certain', 'one', 'or'],
    onyomi: ['ワク', 'コク'],
    kunyomi: ['あ.る', 'あるい.は'],
    examples: [
      KanjiExample(word: '或いは', reading: 'あるいは', meaning: 'or, possibly'),
      KanjiExample(word: '或る', reading: 'ある', meaning: 'a certain'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 8,
    jlptLevel: JlptLevel.n1,
  ),
  KanjiCharacter(
    character: '姻',
    meanings: ['marriage', 'marry'],
    onyomi: ['イン'],
    kunyomi: [],
    examples: [
      KanjiExample(word: '結婚', reading: 'けっこん', meaning: 'marriage'),
      KanjiExample(word: '婚姻', reading: 'こんいん', meaning: 'marriage'),
      KanjiExample(word: '姻戚', reading: 'いんせき', meaning: 'relative by marriage'),
    ],
    grade: KanjiGrade.juniorHigh,
    strokeCount: 9,
    jlptLevel: JlptLevel.n1,
  ),
  // Add remaining 1,111 kanji for production
  // These would include more advanced kanji learned in grades 7-9
];
