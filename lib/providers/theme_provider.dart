import 'package:flutter/material.dart';
import '../utils/storage_helper.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isLoading = true;
  
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  ThemeProvider() {
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    _isDarkMode = await StorageHelper.getThemeMode();
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageHelper.saveThemeMode(_isDarkMode);
    notifyListeners();
  }
  
  Future<void> setThemeMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    await StorageHelper.saveThemeMode(_isDarkMode);
    notifyListeners();
  }
}
