import 'package:flutter/material.dart';

/// Constantes da aplicação
class AppConstants {
  // Limites
  static const int minParticipants = 1;
  static const int maxParticipants = 100;
  static const int minRaces = 1;
  static const int maxRaces = 100;
  static const int defaultRaces = 10;

  // Mensagens
  static const String appName = 'Controle de Armada';
  static const String appVersion = '1.0.0';
  static const String welcomeMessage = 'Bem-vindo ao Controle de Armada!';

  // Durações de animação
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Prefixos de armazenamento
  static const String hiveCompetitionsBox = 'competitions';
  static const String hiveSettingsBox = 'settings';
  static const String sharedPrefThemeKey = 'theme_mode';
}
