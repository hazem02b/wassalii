import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  ThemeMode _themeMode = ThemeMode.light;
  String _locale = 'fr'; // 'fr' ou 'en'
  
  ThemeMode get themeMode => _themeMode;
  String get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    await _storageService.init();
    
    // Charger le thème
    final savedTheme = await _storageService.getThemeMode();
    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
    
    // Charger la langue
    final savedLocale = await _storageService.getLocale();
    if (savedLocale != null) {
      _locale = savedLocale;
    }
    
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storageService.saveThemeMode(mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
  
  Future<void> setLocale(String locale) async {
    _locale = locale;
    await _storageService.saveLocale(locale);
    notifyListeners();
  }
}
