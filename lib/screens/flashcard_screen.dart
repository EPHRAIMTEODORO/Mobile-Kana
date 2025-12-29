import 'dart:math';
import 'package:flutter/material.dart';
import '../data/hiragana_data.dart';
import '../data/katakana_data.dart';
import '../data/all_data.dart';
import '../models/kana_character.dart';
import '../models/kanji_character.dart';
import '../models/kanji_enums.dart';
import '../utils/storage_helper.dart';

enum FlashcardMode { hiragana, katakana, mixed, kanji }

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({Key? key}) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  FlashcardMode _selectedMode = FlashcardMode.hiragana;
  List<dynamic> _cards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadCards();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadCards() {
    setState(() {
      switch (_selectedMode) {
        case FlashcardMode.hiragana:
          _cards = List.from(hiraganaData)..shuffle();
          break;
        case FlashcardMode.katakana:
          _cards = List.from(katakanaData)..shuffle();
          break;
        case FlashcardMode.mixed:
          _cards = [...hiraganaData, ...katakanaData]..shuffle();
          break;
        case FlashcardMode.kanji:
          _cards = List.from(AllData.allKanji)..shuffle();
          break;
      }
      _currentIndex = 0;
      _isFlipped = false;
      _animationController.reset();
    });
  }

  void _flipCard() {
    if (_isFlipped) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard(bool isCorrect) async {
    if (_cards.isEmpty) return;
    
    final currentCard = _cards[_currentIndex];
    String character = '';
    
    if (currentCard is KanaCharacter) {
      character = currentCard.character;
    } else if (currentCard is KanjiCharacter) {
      character = currentCard.character;
    }
    
    await StorageHelper.updateCharacterProgress(character, isCorrect);
    
    setState(() {
      if (_currentIndex >= _cards.length - 1) {
        _cards.shuffle();
        _currentIndex = 0;
      } else {
        _currentIndex++;
      }
      _isFlipped = false;
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildModeSelector(),
              ),
              const SizedBox(height: 16),
              _buildProgressCounter(),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: _buildFlashcard(),
                ),
              ),
              _buildActionButtons(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        Expanded(child: _buildModeButton('Hiragana', FlashcardMode.hiragana)),
        const SizedBox(width: 8),
        Expanded(child: _buildModeButton('Katakana', FlashcardMode.katakana)),
        const SizedBox(width: 8),
        Expanded(child: _buildModeButton('Mixed', FlashcardMode.mixed)),
        const SizedBox(width: 8),
        Expanded(child: _buildModeButton('Kanji', FlashcardMode.kanji)),
      ],
    );
  }

  Widget _buildModeButton(String label, FlashcardMode mode) {
    final isSelected = _selectedMode == mode;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedMode = mode;
        });
        _loadCards();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.indigo.shade600 : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 4 : 1,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildProgressCounter() {
    if (_cards.isEmpty) return const SizedBox();
    
    final total = _cards.length;
    final current = _currentIndex + 1;
    
    return Text(
      _selectedMode == FlashcardMode.kanji
          ? 'Kanji $current of $total'
          : 'Card $current of $total',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFlashcard() {
    if (_cards.isEmpty) {
      return const Text('No cards available');
    }
    
    final currentCard = _cards[_currentIndex];
    
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value;
          final isFront = angle < pi / 2;
          
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? _buildCardFront(currentCard)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildCardBack(currentCard),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardFront(dynamic card) {
    String character = '';
    if (card is KanaCharacter) {
      character = card.character;
    } else if (card is KanjiCharacter) {
      character = card.character;
    }
    
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            character,
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tap to reveal',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(dynamic card) {
    if (card is KanaCharacter) {
      return _buildKanaCardBack(card);
    } else if (card is KanjiCharacter) {
      return _buildKanjiCardBack(card);
    }
    return const SizedBox();
  }

  Widget _buildKanaCardBack(KanaCharacter card) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.romaji,
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card.type == KanaType.hiragana ? 'Hiragana' : 'Katakana',
            style: TextStyle(
              fontSize: 12,
              color: Colors.indigo.shade200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanjiCardBack(KanjiCharacter card) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Meanings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.indigo.shade200,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              card.meanings.take(3).join(', '),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (card.onyomi.isNotEmpty) ...[
              Text(
                'On\'yomi (音読み)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.indigo.shade200,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                card.onyomi.take(3).join(', '),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            if (card.kunyomi.isNotEmpty) ...[
              Text(
                'Kun\'yomi (訓読み)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.indigo.shade200,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                card.kunyomi.take(3).join(', '),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            Text(
              '${_getGradeDisplayName(card.grade)} • ${card.strokeCount ?? '?'} strokes',
              style: TextStyle(
                fontSize: 10,
                color: Colors.indigo.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _nextCard(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Still Learning',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _nextCard(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'I Know This',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGradeDisplayName(KanjiGrade grade) {
    switch (grade) {
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
}
