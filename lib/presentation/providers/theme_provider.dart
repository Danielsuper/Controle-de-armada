import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gerenciar tema da aplicação
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _themeKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Carrega o tema salvo nas preferências
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeValue = prefs.getString(_themeKey) ?? 'system';
    
    _themeMode = _themeFromString(themeValue);
    notifyListeners();
  }

  /// Alterna entre tema claro e escuro
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.light;
    }

    await prefs.setString(_themeKey, _themeToString(_themeMode));
    notifyListeners();
  }

  /// Define o tema
  Future<void> setTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = theme;
    await prefs.setString(_themeKey, _themeToString(theme));
    notifyListeners();
  }

  /// Converte ThemeMode para String
  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Converte String para ThemeMode
  ThemeMode _themeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}