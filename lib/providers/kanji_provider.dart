import 'package:flutter/material.dart';
import '../models/kanji_character.dart';
import '../models/kanji_enums.dart';
import '../data/all_data.dart';
import '../utils/kanji_search.dart';

class KanjiProvider with ChangeNotifier {
  KanjiGrade _selectedGrade = KanjiGrade.grade1;
  List<KanjiCharacter> _displayedKanji = [];
  KanjiCharacter? _selectedKanji;
  String _searchQuery = '';
  Set<String> _selectedJlptLevels = {};
  bool _sortByFrequency = false;
  bool _sortByStrokeCount = false;
  
  KanjiGrade get selectedGrade => _selectedGrade;
  List<KanjiCharacter> get displayedKanji => _displayedKanji;
  KanjiCharacter? get selectedKanji => _selectedKanji;
  String get searchQuery => _searchQuery;
  Set<String> get selectedJlptLevels => _selectedJlptLevels;
  bool get sortByFrequency => _sortByFrequency;
  bool get sortByStrokeCount => _sortByStrokeCount;
  
  KanjiProvider() {
    _loadGradeKanji();
  }
  
  void selectGrade(KanjiGrade grade) {
    _selectedGrade = grade;
    _loadGradeKanji();
  }
  
  void _loadGradeKanji() {
    _displayedKanji = AllData.getKanjiByGrade(_selectedGrade);
    _applyFiltersAndSorting();
  }
  
  void selectKanji(KanjiCharacter? kanji) {
    _selectedKanji = kanji;
    notifyListeners();
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSorting();
  }
  
  void toggleJlptFilter(String level) {
    if (_selectedJlptLevels.contains(level)) {
      _selectedJlptLevels.remove(level);
    } else {
      _selectedJlptLevels.add(level);
    }
    _applyFiltersAndSorting();
  }
  
  void clearJlptFilters() {
    _selectedJlptLevels.clear();
    _applyFiltersAndSorting();
  }
  
  void toggleFrequencySort() {
    _sortByFrequency = !_sortByFrequency;
    if (_sortByFrequency) {
      _sortByStrokeCount = false;
    }
    _applyFiltersAndSorting();
  }
  
  void toggleStrokeCountSort() {
    _sortByStrokeCount = !_sortByStrokeCount;
    if (_sortByStrokeCount) {
      _sortByFrequency = false;
    }
    _applyFiltersAndSorting();
  }
  
  void clearFilters() {
    _searchQuery = '';
    _selectedJlptLevels.clear();
    _sortByFrequency = false;
    _sortByStrokeCount = false;
    _loadGradeKanji();
  }
  
  void _applyFiltersAndSorting() {
    var result = AllData.getKanjiByGrade(_selectedGrade);
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      result = KanjiSearch.search(result, _searchQuery);
    }
    
    // Apply JLPT filter
    if (_selectedJlptLevels.isNotEmpty) {
      result = KanjiSearch.filterByJlpt(result, _selectedJlptLevels);
    }
    
    // Apply sorting
    if (_sortByFrequency) {
      result = KanjiSearch.sortByFrequency(result, ascending: true);
    } else if (_sortByStrokeCount) {
      result = KanjiSearch.sortByStrokeCount(result, ascending: true);
    }
    
    _displayedKanji = result;
    notifyListeners();
  }
  
  List<KanjiCharacter> getSimilarKanji(KanjiCharacter kanji) {
    return KanjiSearch.findSimilar(kanji, AllData.allKanji);
  }
  
  List<KanjiCharacter> getAllKanjiUpToGrade(KanjiGrade grade) {
    final List<KanjiCharacter> result = [];
    
    for (var g in KanjiGrade.values) {
      result.addAll(AllData.getKanjiByGrade(g));
      if (g == grade) break;
    }
    
    return result;
  }
}
