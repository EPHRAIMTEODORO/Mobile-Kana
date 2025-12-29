import 'package:flutter/material.dart';
import '../data/hiragana_data.dart';
import '../data/katakana_data.dart';
import '../models/kana_character.dart';

enum ChartMode { hiragana, katakana, both }

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  ChartMode _selectedMode = ChartMode.hiragana;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kana Chart'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade50,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildModeSelector(),
              const SizedBox(height: 24),
              _buildCharts(),
              const SizedBox(height: 24),
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildModeButton(
            'Hiragana Only',
            ChartMode.hiragana,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildModeButton(
            'Katakana Only',
            ChartMode.katakana,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildModeButton(
            'Both',
            ChartMode.both,
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton(String label, ChartMode mode) {
    final isSelected = _selectedMode == mode;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedMode = mode),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink.shade600 : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 4 : 1,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildCharts() {
    if (_selectedMode == ChartMode.both) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildKanaChart(hiraganaData, 'Hiragana')),
                const SizedBox(width: 16),
                Expanded(child: _buildKanaChart(katakanaData, 'Katakana')),
              ],
            );
          } else {
            return Column(
              children: [
                _buildKanaChart(hiraganaData, 'Hiragana'),
                const SizedBox(height: 16),
                _buildKanaChart(katakanaData, 'Katakana'),
              ],
            );
          }
        },
      );
    } else if (_selectedMode == ChartMode.hiragana) {
      return _buildKanaChart(hiraganaData, 'Hiragana');
    } else {
      return _buildKanaChart(katakanaData, 'Katakana');
    }
  }

  Widget _buildKanaChart(List<KanaCharacter> data, String title) {
    final chartData = _organizeChart(data);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildChartGrid(chartData),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, String>> _organizeChart(List<KanaCharacter> data) {
    final chart = {
      '': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'k': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      's': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      't': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'n': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'h': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'm': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'y': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'r': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
      'w': {'a': '', 'i': '', 'u': '', 'e': '', 'o': ''},
    };

    for (var char in data) {
      if (char.romaji == 'n' && char.romaji.length == 1) continue;
      
      String row = '';
      String col = char.romaji[char.romaji.length - 1];
      
      if (char.romaji.length == 1) {
        row = '';
      } else if (char.romaji == 'shi') {
        row = 's'; col = 'i';
      } else if (char.romaji == 'chi') {
        row = 't'; col = 'i';
      } else if (char.romaji == 'tsu') {
        row = 't'; col = 'u';
      } else if (char.romaji == 'fu') {
        row = 'h'; col = 'u';
      } else if (char.romaji == 'wo') {
        row = 'w'; col = 'o';
      } else {
        row = char.romaji[0];
      }
      
      if (chart.containsKey(row) && chart[row]!.containsKey(col)) {
        chart[row]![col] = char.character;
      }
    }
    
    return chart;
  }

  Widget _buildChartGrid(Map<String, Map<String, String>> chartData) {
    final rows = ['', 'k', 's', 't', 'n', 'h', 'm', 'y', 'r', 'w'];
    final cols = ['a', 'i', 'u', 'e', 'o'];
    
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            _buildHeaderCell(''),
            ...cols.map((col) => _buildHeaderCell(col.toUpperCase())),
          ],
        ),
        ...rows.map((row) {
          return TableRow(
            children: [
              _buildHeaderCell(row.toUpperCase()),
              ...cols.map((col) {
                final char = chartData[row]![col]!;
                return _buildKanaCell(char, _getRomaji(char, row, col));
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildKanaCell(String character, String romaji) {
    if (character.isEmpty) {
      return const SizedBox(height: 60);
    }
    
    return InkWell(
      onTap: () {},
      child: Container(
        height: 60,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              character,
              style: const TextStyle(fontSize: 28),
            ),
            Text(
              romaji,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRomaji(String char, String row, String col) {
    if (char.isEmpty) return '';
    if (row == '' && col == 'a') return 'a';
    if (row == '' && col == 'i') return 'i';
    if (row == '' && col == 'u') return 'u';
    if (row == '' && col == 'e') return 'e';
    if (row == '' && col == 'o') return 'o';
    if (row == 's' && col == 'i') return 'shi';
    if (row == 't' && col == 'i') return 'chi';
    if (row == 't' && col == 'u') return 'tsu';
    if (row == 'h' && col == 'u') return 'fu';
    if (row == 'w' && col == 'o') return 'wo';
    return row + col;
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the Kana Chart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  height: 1.6,
                ),
                children: const [
                  TextSpan(
                    text: 'Hiragana (ひらがな)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' is used for native Japanese words, grammatical elements, and when kanji is too difficult.\n\n',
                  ),
                  TextSpan(
                    text: 'Katakana (カタカナ)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' is primarily used for foreign loanwords, onomatopoeia, and emphasis.\n\n',
                  ),
                  TextSpan(
                    text: 'The chart shows the basic kana organized by consonant rows and vowel columns.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
