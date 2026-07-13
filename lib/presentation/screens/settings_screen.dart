import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/theme_provider.dart';

/// Tela de Configurações
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Seção de Tema
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          title: const Text('Tema Claro'),
                          value: ThemeMode.light,
                          groupValue: themeProvider.themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              themeProvider.setTheme(value);
                            }
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Tema Escuro'),
                          value: ThemeMode.dark,
                          groupValue: themeProvider.themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              themeProvider.setTheme(value);
                            }
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Do Sistema'),
                          value: ThemeMode.system,
                          groupValue: themeProvider.themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              themeProvider.setTheme(value);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Seção de Backup
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backup e Restauração',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showBackupDialog(context);
                    },
                    icon: const Icon(Icons.backup),
                    label: const Text('Criar Backup'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showRestoreDialog(context);
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Restaurar Backup'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Seção de Informações
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sobre',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Versão'),
                  subtitle: const Text('1.0.0'),
                  leading: const Icon(Icons.info),
                ),
                const SizedBox(height: 8),
                Text(
                  'Controle de Armada é um aplicativo profissional para registrar rapidamente os resultados de armadas em competições.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo de backup
  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup'),
        content: const Text(
          'Funcionalidade de backup será implementada em breve. Seus dados já são salvos automaticamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo de restauração
  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Backup'),
        content: const Text(
          'Funcionalidade de restauração será implementada em breve.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
