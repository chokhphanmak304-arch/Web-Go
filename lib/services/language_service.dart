import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _keyLanguage = 'app_language';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_keyLanguage) ?? 'en';
    _locale = Locale(langCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, locale.languageCode);
    notifyListeners();
  }

  bool get isEnglish => _locale.languageCode == 'en';
  bool get isThai => _locale.languageCode == 'th';
}
