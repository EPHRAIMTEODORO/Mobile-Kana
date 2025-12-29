import 'package:flutter/material.dart';
import '../data/all_data.dart';
import '../models/kanji_character.dart';
import '../models/kanji_enums.dart';

class GradeInfo {
  final KanjiGrade grade;
  final String name;
  final String nameJP;
  final int count;

  const GradeInfo({
    required this.grade,
    required this.name,
    required this.nameJP,
    required this.count,
  });
}

class KanjiBrowserScreen extends StatefulWidget {
  const KanjiBrowserScreen({Key? key}) : super(key: key);

  @override
  State<KanjiBrowserScreen> createState() => _KanjiBrowserScreenState();
}

class _KanjiBrowserScreenState extends State<KanjiBrowserScreen> {
  KanjiGrade _selectedGrade = KanjiGrade.grade1;
  KanjiCharacter? _selectedKanji;

  final List<GradeInfo> _grades = const [
    GradeInfo(
      grade: KanjiGrade.grade1,
      name: 'Grade 1',
      nameJP: '第一学年',
      count: 80,
    ),
    GradeInfo(
      grade: KanjiGrade.grade2,
      name: 'Grade 2',
      nameJP: '第二学年',
      count: 160,
    ),
    GradeInfo(
      grade: KanjiGrade.grade3,
      name: 'Grade 3',
      nameJP: '第三学年',
      count: 200,
    ),
    GradeInfo(
      grade: KanjiGrade.grade4,
      name: 'Grade 4',
      nameJP: '第四学年',
      count: 200,
    ),
    GradeInfo(
      grade: KanjiGrade.grade5,
      name: 'Grade 5',
      nameJP: '第五学年',
      count: 185,
    ),
    GradeInfo(
      grade: KanjiGrade.grade6,
      name: 'Grade 6',
      nameJP: '第六学年',
      count: 181,
    ),
    GradeInfo(
      grade: KanjiGrade.juniorHigh,
      name: 'Junior High',
      nameJP: '中学校',
      count: 1134,
    ),
  ];

  List<KanjiCharacter> get _currentKanjiList {
    return AllData.allKanji
        .where((k) => k.grade == _selectedGrade)
        .toList();
  }

  void _showKanjiDetail(KanjiCharacter kanji) {
    setState(() {
      _selectedKanji = kanji;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildKanjiDetailSheet(kanji),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanji Browser'),
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
        child: Column(
          children: [
            _buildGradeSelector(),
            _buildCurrentSectionInfo(),
            Expanded(child: _buildKanjiGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white.withOpacity(0.9),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1000) {
            crossAxisCount = 7;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 4;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
            ),
            itemCount: _grades.length,
            itemBuilder: (context, index) {
              final grade = _grades[index];
              return _buildGradeButton(grade);
            },
          );
        },
      ),
    );
  }

  Widget _buildGradeButton(GradeInfo gradeInfo) {
    final isSelected = _selectedGrade == gradeInfo.grade;
    return InkWell(
      onTap: () => setState(() {
        _selectedGrade = gradeInfo.grade;
        _selectedKanji = null;
      }),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.purple.shade500 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gradeInfo.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              gradeInfo.nameJP,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '${gradeInfo.count}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSectionInfo() {
    final currentGrade = _grades.firstWhere((g) => g.grade == _selectedGrade);
    final kanjiList = _currentKanjiList;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${currentGrade.name} (${currentGrade.nameJP})',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getGradeDescription(_selectedGrade),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Available: ${kanjiList.length} kanji',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.purple.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGradeDescription(KanjiGrade grade) {
    switch (grade) {
      case KanjiGrade.grade1:
        return 'Basic kanji learned in first grade of elementary school. These are the simplest and most fundamental characters.';
      case KanjiGrade.grade2:
        return 'Kanji learned in second grade. Builds upon Grade 1 with slightly more complex characters.';
      case KanjiGrade.grade3:
        return 'Kanji learned in third grade. Introduces more abstract concepts and compound forms.';
      case KanjiGrade.grade4:
        return 'Kanji learned in fourth grade. Covers more specialized vocabulary and concepts.';
      case KanjiGrade.grade5:
        return 'Kanji learned in fifth grade. Includes more advanced characters used in daily life.';
      case KanjiGrade.grade6:
        return 'Kanji learned in sixth grade. Completes elementary education kanji set.';
      case KanjiGrade.juniorHigh:
        return 'Kanji learned in junior high school (7th-9th grade). Advanced characters for higher education.';
    }
  }

  Widget _buildKanjiGrid() {
    final kanjiList = _currentKanjiList;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        if (constraints.maxWidth > 1000) {
          crossAxisCount = 12;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 8;
        } else if (constraints.maxWidth > 400) {
          crossAxisCount = 6;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: kanjiList.length,
          itemBuilder: (context, index) {
            final kanji = kanjiList[index];
            return _buildKanjiCell(kanji);
          },
        );
      },
    );
  }

  Widget _buildKanjiCell(KanjiCharacter kanji) {
    final isSelected = _selectedKanji?.character == kanji.character;
    return InkWell(
      onTap: () => _showKanjiDetail(kanji),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.purple.shade500 : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.purple.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            kanji.character,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKanjiDetailSheet(KanjiCharacter kanji) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kanji Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKanjiDisplay(kanji),
                      const SizedBox(height: 24),
                      _buildMeaningsSection(kanji),
                      const SizedBox(height: 24),
                      if (kanji.onyomi.isNotEmpty) ...[
                        _buildOnYomiSection(kanji),
                        const SizedBox(height: 24),
                      ],
                      if (kanji.kunyomi.isNotEmpty) ...[
                        _buildKunYomiSection(kanji),
                        const SizedBox(height: 24),
                      ],
                      if (kanji.examples.isNotEmpty) ...[
                        _buildExamplesSection(kanji),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKanjiDisplay(KanjiCharacter kanji) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                kanji.character,
                style: const TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${kanji.strokeCount ?? '?'} strokes',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (kanji.jlptLevel != null) ...[
                const Text(' | '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'JLPT ${kanji.jlptLevel!.displayName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningsSection(KanjiCharacter kanji) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEANINGS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kanji.meanings.map((meaning) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                meaning,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade800,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOnYomiSection(KanjiCharacter kanji) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ON\'YOMI (音読み)',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kanji.onyomi.map((reading) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                reading,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade800,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKunYomiSection(KanjiCharacter kanji) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KUN\'YOMI (訓読み)',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kanji.kunyomi.map((reading) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                reading,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade800,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExamplesSection(KanjiCharacter kanji) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXAMPLES',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        ...kanji.examples.take(5).map((example) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      example.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      example.reading,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  example.meaning,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
