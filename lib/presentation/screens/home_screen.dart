import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/models.dart';
import '../../presentation/providers/competition_provider.dart';
import 'new_competition_screen.dart';
import 'saved_competitions_screen.dart';
import 'competition_main_screen.dart';

/// Tela inicial do aplicativo
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Competition? _lastCompetition;

  @override
  void initState() {
    super.initState();
    _loadLastCompetition();
  }

  /// Carrega a última competição
  void _loadLastCompetition() {
    final provider = context.read<CompetitionProvider>();
    final competitions = provider.getAllCompetitions();
    if (competitions.isNotEmpty) {
      _lastCompetition = competitions.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Armada'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegará para tela de configurações
              _navigateToSettings(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Título
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bem-vindo!',
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Registre os resultados de suas armadas',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Botão: Nova Planilha
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NewCompetitionScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                  label: const Text(
                    'Nova Planilha',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botão: Continuar Última
              if (_lastCompetition != null)
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _continueLastCompetition(context);
                    },
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Continuar Última',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          _lastCompetition!.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_lastCompetition != null) const SizedBox(height: 16),

              // Botão: Planilhas Salvas
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SavedCompetitionsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.folder_open, size: 28),
                  label: const Text(
                    'Planilhas Salvas',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Continua a última competição
  void _continueLastCompetition(BuildContext context) {
    if (_lastCompetition == null) return;

    final provider = context.read<CompetitionProvider>();
    final competitions = provider.getAllCompetitions();
    final index = competitions.indexWhere((c) => c.id == _lastCompetition!.id);

    if (index != -1) {
      provider.loadCompetition(index).then((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CompetitionMainScreen(),
          ),
        );
      });
    }
  }

  /// Navega para a tela de configurações
  void _navigateToSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Configurações',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.brightness_4),
              title: const Text('Alternar Tema'),
              onTap: () {
                context.read<ThemeProvider>().toggleTheme();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Import adicional necessário
import '../../presentation/providers/theme_provider.dart';
