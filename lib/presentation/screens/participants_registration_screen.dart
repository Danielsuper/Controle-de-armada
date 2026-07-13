import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/models.dart';
import '../../presentation/providers/competition_provider.dart';
import 'competition_main_screen.dart';

/// Tela para registrar participantes
class ParticipantsRegistrationScreen extends StatefulWidget {
  final Competition competition;

  const ParticipantsRegistrationScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  State<ParticipantsRegistrationScreen> createState() =>
      _ParticipantsRegistrationScreenState();
}

class _ParticipantsRegistrationScreenState
    extends State<ParticipantsRegistrationScreen> {
  late List<Participant> _participants;
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _participants = List.from(widget.competition.participants);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  /// Adiciona ou atualiza um participante
  void _addOrUpdateParticipant() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome')),
      );
      return;
    }

    final participant = Participant(
      name: _nameController.text,
      number: _numberController.text.isEmpty ? null : _numberController.text,
      order: _editingIndex != null ? _participants[_editingIndex!].order : _participants.length + 1,
    );

    setState(() {
      if (_editingIndex != null) {
        _participants[_editingIndex!] = participant;
        _editingIndex = null;
      } else {
        _participants.add(participant);
      }
    });

    _nameController.clear();
    _numberController.clear();
  }

  /// Edita um participante
  void _editParticipant(int index) {
    setState(() {
      _editingIndex = index;
      _nameController.text = _participants[index].name;
      _numberController.text = _participants[index].number ?? '';
    });
  }

  /// Remove um participante
  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _nameController.clear();
        _numberController.clear();
      }
    });
  }

  /// Prossegue para a tela principal
  void _startCompetition() {
    if (_participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, adicione pelo menos um participante'),
        ),
      );
      return;
    }

    final updatedCompetition = widget.competition.copyWith(
      participants: _participants,
    );

    final provider = context.read<CompetitionProvider>();
    provider.createCompetition(
      name: updatedCompetition.name,
      totalRaces: updatedCompetition.totalRaces,
      participants: _participants,
    ).then((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const CompetitionMainScreen(),
        ),
        (route) => route.isFirst,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Participantes'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Formulário de entrada
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surface,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nome do participante',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _numberController,
                        decoration: const InputDecoration(
                          hintText: 'Número (opcional)',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 60,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _addOrUpdateParticipant,
                        child: Icon(
                          _editingIndex != null ? Icons.check : Icons.add,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de participantes
          Expanded(
            child: _participants.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum participante adicionado',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _participants.length,
                    itemBuilder: (context, index) {
                      final participant = _participants[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(participant.name),
                          subtitle: participant.number != null
                              ? Text('Nº ${participant.number}')
                              : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editParticipant(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: colorScheme.error,
                                onPressed: () => _removeParticipant(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Botão Iniciar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 72,
              child: ElevatedButton.icon(
                onPressed: _startCompetition,
                icon: const Icon(Icons.play_arrow, size: 24),
                label: const Text(
                  'Iniciar Competição',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
