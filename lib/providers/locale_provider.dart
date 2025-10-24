import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es'); // Español por defecto
  
  Locale get locale => _locale;
  
  Future<void> setLocale(Locale locale) async {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    
    _locale = locale;
    notifyListeners();
    
    // Guardar la preferencia del usuario
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
  
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'es';
    _locale = Locale(localeCode);
    notifyListeners();
  }
}