import '../models/kanji_character.dart';
import '../models/kanji_enums.dart';

class KanjiSearch {
  /// Search kanji by character, meaning, or reading
  static List<KanjiCharacter> search(
    List<KanjiCharacter> kanjiList,
    String query,
  ) {
    if (query.isEmpty) return kanjiList;
    
    final lowerQuery = query.toLowerCase();
    
    return kanjiList.where((kanji) {
      // Search by character
      if (kanji.character.contains(query)) return true;
      
      // Search by meaning
      if (kanji.meanings.any((m) => m.toLowerCase().contains(lowerQuery))) {
        return true;
      }
      
      // Search by onyomi
      if (kanji.onyomi.any((o) => o.contains(query))) return true;
      
      // Search by kunyomi
      if (kanji.kunyomi.any((k) => k.contains(query))) return true;
      
      // Search by example words
      if (kanji.examples.any((ex) =>
          ex.word.contains(query) ||
          ex.reading.contains(query) ||
          ex.meaning.toLowerCase().contains(lowerQuery))) {
        return true;
      }
      
      return false;
    }).toList();
  }
  
  /// Filter kanji by JLPT level
  static List<KanjiCharacter> filterByJlpt(
    List<KanjiCharacter> kanjiList,
    Set<String> selectedLevels,
  ) {
    if (selectedLevels.isEmpty) return kanjiList;
    
    return kanjiList.where((kanji) {
      if (kanji.jlptLevel == null) return false;
      return selectedLevels.contains(kanji.jlptLevel!.displayName);
    }).toList();
  }
  
  /// Sort kanji by frequency
  static List<KanjiCharacter> sortByFrequency(
    List<KanjiCharacter> kanjiList, {
    bool ascending = true,
  }) {
    final sorted = List<KanjiCharacter>.from(kanjiList);
    
    sorted.sort((a, b) {
      final freqA = a.frequency ?? 999999;
      final freqB = b.frequency ?? 999999;
      return ascending ? freqA.compareTo(freqB) : freqB.compareTo(freqA);
    });
    
    return sorted;
  }
  
  /// Sort kanji by stroke count
  static List<KanjiCharacter> sortByStrokeCount(
    List<KanjiCharacter> kanjiList, {
    bool ascending = true,
  }) {
    final sorted = List<KanjiCharacter>.from(kanjiList);
    
    sorted.sort((a, b) {
      final strokeA = a.strokeCount ?? 999;
      final strokeB = b.strokeCount ?? 999;
      return ascending ? strokeA.compareTo(strokeB) : strokeB.compareTo(strokeA);
    });
    
    return sorted;
  }
  
  /// Find similar kanji (by radical or visual similarity)
  /// This is a placeholder - would need a proper similarity algorithm
  static List<KanjiCharacter> findSimilar(
    KanjiCharacter kanji,
    List<KanjiCharacter> allKanji,
  ) {
    if (kanji.radicals == null) return [];
    
    return allKanji.where((k) {
      if (k.character == kanji.character) return false;
      if (k.radicals == null) return false;
      
      // Check if they share any radicals
      return k.radicals!.any((r) => kanji.radicals!.contains(r));
    }).take(5).toList();
  }
}
