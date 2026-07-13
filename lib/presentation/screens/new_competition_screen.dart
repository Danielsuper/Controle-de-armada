import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/models.dart';
import '../../presentation/providers/competition_provider.dart';
import 'participants_registration_screen.dart';

/// Tela para criar uma nova competição
class NewCompetitionScreen extends StatefulWidget {
  const NewCompetitionScreen({Key? key}) : super(key: key);

  @override
  State<NewCompetitionScreen> createState() => _NewCompetitionScreenState();
}

class _NewCompetitionScreenState extends State<NewCompetitionScreen> {
  final _competitionNameController = TextEditingController();
  int _totalRaces = 10;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _competitionNameController.dispose();
    super.dispose();
  }

  /// Valida o formulário e prossegue
  void _proceedToParticipants() {
    if (_competitionNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome da competição')),
      );
      return;
    }

    final competition = Competition(
      name: _competitionNameController.text,
      date: _selectedDate,
      totalRaces: _totalRaces,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ParticipantsRegistrationScreen(
          competition: competition,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Planilha'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome da Competição
            Text(
              'Nome da Competição',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _competitionNameController,
              decoration: InputDecoration(
                hintText: 'Ex: Campeonato Regional 2024',
                prefixIcon: const Icon(Icons.emoji_events),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 32),

            // Data
            Text(
              'Data',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2099),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surface,
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Quantidade de Armadas
            Text(
              'Quantidade de Armadas',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    if (_totalRaces > 1) _totalRaces--;
                  }),
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_totalRaces',
                      style: theme.textTheme.displayMedium,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    if (_totalRaces < 100) _totalRaces++;
                  }),
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Botão Próximo
            SizedBox(
              width: double.infinity,
              height: 72,
              child: ElevatedButton.icon(
                onPressed: _proceedToParticipants,
                icon: const Icon(Icons.arrow_forward, size: 24),
                label: const Text(
                  'Próximo: Participantes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
