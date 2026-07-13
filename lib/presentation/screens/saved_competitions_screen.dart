import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/models.dart';
import '../../presentation/providers/competition_provider.dart';
import 'competition_main_screen.dart';

/// Tela de competições salvas
class SavedCompetitionsScreen extends StatefulWidget {
  const SavedCompetitionsScreen({Key? key}) : super(key: key);

  @override
  State<SavedCompetitionsScreen> createState() =>
      _SavedCompetitionsScreenState();
}

class _SavedCompetitionsScreenState extends State<SavedCompetitionsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planilhas Salvas'),
        elevation: 0,
      ),
      body: Consumer<CompetitionProvider>(
        builder: (context, provider, _) {
          final competitions = provider.getAllCompetitions();

          if (competitions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma competição salva',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: competitions.length,
            itemBuilder: (context, index) {
              final competition = competitions[index];
              final dateFormat = DateFormat('dd/MM/yyyy');

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Icons.emoji_events,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  title: Text(
                    competition.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Data: ${dateFormat.format(competition.date)}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Participantes: ${competition.participants.length}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Última alteração: ${dateFormat.format(competition.updatedAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      _handleMenuAction(context, value, index, competition);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'continue',
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text('Continuar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Renomear'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.content_copy),
                            SizedBox(width: 8),
                            Text('Duplicar'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Excluir'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _continueCompetition(context, index),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Continua uma competição
  void _continueCompetition(BuildContext context, int index) {
    final provider = context.read<CompetitionProvider>();
    provider.loadCompetition(index).then((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CompetitionMainScreen(),
        ),
      );
    });
  }

  /// Lida com ações do menu
  void _handleMenuAction(
    BuildContext context,
    String action,
    int index,
    Competition competition,
  ) {
    final provider = context.read<CompetitionProvider>();

    switch (action) {
      case 'continue':
        _continueCompetition(context, index);
        break;
      case 'rename':
        _showRenameDialog(context, provider, index, competition);
        break;
      case 'duplicate':
        _showDuplicateDialog(context, provider, index);
        break;
      case 'delete':
        _showDeleteConfirmation(context, provider, index);
        break;
    }
  }

  /// Mostra diálogo para renomear
  void _showRenameDialog(
    BuildContext context,
    CompetitionProvider provider,
    int index,
    Competition competition,
  ) {
    final controller = TextEditingController(text: competition.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear Competição'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Novo nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final updated = competition.copyWith(
                  name: controller.text,
                );
                provider.updateCurrentCompetition().then((_) {
                  Navigator.pop(context);
                  setState(() {});
                });
              }
            },
            child: const Text('Renomear'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para duplicar
  void _showDuplicateDialog(
    BuildContext context,
    CompetitionProvider provider,
    int index,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicar Competição'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome da cópia'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.duplicateCompetition(index, controller.text).then((_) {
                  Navigator.pop(context);
                  setState(() {});
                });
              }
            },
            child: const Text('Duplicar'),
          ),
        ],
      ),
    );
  }

  /// Mostra confirmação de exclusão
  void _showDeleteConfirmation(
    BuildContext context,
    CompetitionProvider provider,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Competição?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCompetition(index).then((_) {
                Navigator.pop(context);
                setState(() {});
              });
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
