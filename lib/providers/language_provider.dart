import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'language';
  String _currentLanguage = 'en';

  LanguageProvider() {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  bool get isArabic => _currentLanguage == 'ar';

  bool get isRTL => _currentLanguage == 'ar';

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(BuildContext context, String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      await context.setLocale(Locale(languageCode));
      
      notifyListeners();
    }
  }

  Future<void> toggleLanguage(BuildContext context) async {
    final newLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
    await setLanguage(context, newLanguage);
    await setLanguage(context, newLanguage);
  }
}
