import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'data/models/models.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/competition_provider.dart';

void main() async {
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar adapters
  Hive.registerAdapter(CompetitionAdapter());
  Hive.registerAdapter(ParticipantAdapter());
  Hive.registerAdapter(RaceResultAdapter());
  
  // Abrir boxes
  await Hive.openBox<Competition>('competitions');
  await Hive.openBox<String>('settings');
  
  runApp(const ControleArmadasApp());
}

class ControleArmadasApp extends StatelessWidget {
  const ControleArmadasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CompetitionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Controle de Armada',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}