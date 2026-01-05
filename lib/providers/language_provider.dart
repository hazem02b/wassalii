import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageProvider extends ChangeNotifier {
  final LanguageService _languageService = LanguageService();
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    _locale = await _languageService.getLocale();
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    await _languageService.setLanguage(languageCode);
    notifyListeners();
  }

  Future<String> getCurrentLanguageName() async {
    return await _languageService.getCurrentLanguageName();
  }

  Future<String> getCurrentLanguageFlag() async {
    return await _languageService.getCurrentLanguageFlag();
  }
}
