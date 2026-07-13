import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/models.dart';
import '../../presentation/providers/competition_provider.dart';

/// Tela principal de registro de armadas
class CompetitionMainScreen extends StatefulWidget {
  const CompetitionMainScreen({Key? key}) : super(key: key);

  @override
  State<CompetitionMainScreen> createState() => _CompetitionMainScreenState();
}

class _CompetitionMainScreenState extends State<CompetitionMainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Registra um resultado (P ou N)
  void _registerResult(String result) {
    context.read<CompetitionProvider>().registerResult(result).then((_) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        _confirmExit();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<CompetitionProvider>(
            builder: (context, provider, _) {
              final competition = provider.currentCompetition;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(competition?.name ?? 'Competição'),
                  Text(
                    'Armada ${provider.currentRaceIndex + 1}/${competition?.totalRaces ?? 0}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
          elevation: 0,
          actions: [
            Consumer<CompetitionProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: provider.canUndo
                          ? () => provider.undo()
                          : null,
                      tooltip: 'Desfazer',
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      onPressed: provider.canRedo
                          ? () => provider.redo()
                          : null,
                      tooltip: 'Refazer',
                    ),
                    IconButton(
                      icon: const Icon(Icons.bar_chart),
                      onPressed: _showStatistics,
                      tooltip: 'Estatísticas',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<CompetitionProvider>(
          builder: (context, provider, _) {
            final competition = provider.currentCompetition;
            if (competition == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // Header com informações
                Container(
                  padding: const EdgeInsets.all(16),
                  color: colorScheme.primary.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'P',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                          Consumer<CompetitionProvider>(
                            builder: (context, provider, _) {
                              final stats = provider.getStatistics();
                              return Text(
                                '${stats['p_count'] ?? 0}',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Total',
                            style: theme.textTheme.titleMedium,
                          ),
                          Consumer<CompetitionProvider>(
                            builder: (context, provider, _) {
                              final stats = provider.getStatistics();
                              return Text(
                                '${stats['total'] ?? 0}',
                                style: theme.textTheme.displayMedium,
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'N',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                          Consumer<CompetitionProvider>(
                            builder: (context, provider, _) {
                              final stats = provider.getStatistics();
                              return Text(
                                '${stats['n_count'] ?? 0}',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tabela de participantes
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          const DataColumn(label: Text('Participante')),
                          ...List.generate(
                            competition.totalRaces,
                            (index) => DataColumn(
                              label: Text('${index + 1}'),
                              numeric: false,
                            ),
                          ),
                        ],
                        rows: List.generate(
                          competition.participants.length,
                          (participantIndex) {
                            final participant =
                                competition.participants[participantIndex];
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    participant.name,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                                ...List.generate(
                                  competition.totalRaces,
                                  (raceIndex) {
                                    final result = provider.getResult(
                                      participant.id,
                                      raceIndex,
                                    );
                                    return DataCell(
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          result ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: result == 'P'
                                                ? Colors.green
                                                : result == 'N'
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'btn_p',
              backgroundColor: Colors.green,
              onPressed: () => _registerResult('P'),
              icon: const Icon(Icons.check_circle, size: 32),
              label: const Text(
                'P',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'btn_n',
              backgroundColor: Colors.red,
              onPressed: () => _registerResult('N'),
              icon: const Icon(Icons.cancel, size: 32),
              label: const Text(
                'N',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra estatísticas
  void _showStatistics() {
    final provider = context.read<CompetitionProvider>();
    final stats = provider.getStatistics();
    final pPercentage = stats['p_percentage'] ?? '0.0';
    final nPercentage = stats['n_percentage'] ?? '0.0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estatísticas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatisticRow(
              label: 'Praia',
              count: stats['p_count'] ?? 0,
              percentage: pPercentage,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _StatisticRow(
              label: 'Nado',
              count: stats['n_count'] ?? 0,
              percentage: nPercentage,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Total: ${stats['total'] ?? 0}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  /// Confirma saída
  void _confirmExit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair?'),
        content: const Text('Sua competição será salva automaticamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

/// Widget para exibir estatísticas
class _StatisticRow extends StatelessWidget {
  final String label;
  final int count;
  final String percentage;
  final Color color;

  const _StatisticRow({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                color: color.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
