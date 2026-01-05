import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  static const String defaultLanguage = 'fr';

  // Langues supportées
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇹🇳'},
  ];

  // Sauvegarder la langue
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // Récupérer la langue sauvegardée
  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? defaultLanguage;
  }

  // Obtenir le Locale
  Future<Locale> getLocale() async {
    final languageCode = await getLanguage();
    return Locale(languageCode);
  }

  // Obtenir le nom de la langue actuelle
  Future<String> getCurrentLanguageName() async {
    final code = await getLanguage();
    final lang = supportedLanguages.firstWhere(
      (l) => l['code'] == code,
      orElse: () => supportedLanguages[0],
    );
    return lang['name']!;
  }

  // Obtenir le drapeau de la langue actuelle
  Future<String> getCurrentLanguageFlag() async {
    final code = await getLanguage();
    final lang = supportedLanguages.firstWhere(
      (l) => l['code'] == code,
      orElse: () => supportedLanguages[0],
    );
    return lang['flag']!;
  }
}
