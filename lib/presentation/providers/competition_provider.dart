import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/models.dart';

/// Provider para gerenciar o estado das competições
class CompetitionProvider extends ChangeNotifier {
  late Box<Competition> _competitionBox;
  Competition? _currentCompetition;
  List<RaceResult> _undoStack = [];
  List<RaceResult> _redoStack = [];
  int _currentParticipantIndex = 0;
  int _currentRaceIndex = 0;

  Competition? get currentCompetition => _currentCompetition;
  int get currentParticipantIndex => _currentParticipantIndex;
  int get currentRaceIndex => _currentRaceIndex;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  CompetitionProvider() {
    _initializeBox();
  }

  /// Inicializa a box Hive
  Future<void> _initializeBox() async {
    _competitionBox = Hive.box<Competition>('competitions');
    notifyListeners();
  }

  /// Cria uma nova competição
  Future<void> createCompetition({
    required String name,
    required int totalRaces,
    required List<Participant> participants,
  }) async {
    final competition = Competition(
      name: name,
      totalRaces: totalRaces,
      participants: participants,
    );

    await _competitionBox.add(competition);
    _currentCompetition = competition;
    _currentParticipantIndex = 0;
    _currentRaceIndex = 0;
    _undoStack = [];
    _redoStack = [];
    notifyListeners();
  }

  /// Carrega uma competição existente
  Future<void> loadCompetition(int index) async {
    _currentCompetition = _competitionBox.getAt(index);
    _currentParticipantIndex = 0;
    _currentRaceIndex = 0;
    _undoStack = [];
    _redoStack = [];
    notifyListeners();
  }

  /// Atualiza a competição atual
  Future<void> updateCurrentCompetition() async {
    if (_currentCompetition != null) {
      final index = _competitionBox.values
          .toList()
          .indexWhere((c) => c.id == _currentCompetition!.id);
      if (index != -1) {
        await _competitionBox.putAt(index, _currentCompetition!);
        notifyListeners();
      }
    }
  }

  /// Registra um resultado de armada
  Future<void> registerResult(String result) async {
    if (_currentCompetition == null) return;

    final participant = _currentCompetition!.participants[_currentParticipantIndex];
    
    // Verifica se já existe resultado para esta armada
    final existingResult = _currentCompetition!.results.firstWhere(
      (r) => r.participantId == participant.id && r.raceNumber == _currentRaceIndex,
      orElse: () => RaceResult(
        participantId: participant.id,
        raceNumber: _currentRaceIndex,
        result: '',
      ),
    );

    // Cria novo resultado
    final newResult = RaceResult(
      participantId: participant.id,
      raceNumber: _currentRaceIndex,
      result: result,
    );

    // Atualiza ou adiciona
    final resultIndex = _currentCompetition!.results.indexOf(existingResult);
    if (resultIndex != -1) {
      _undoStack.add(existingResult);
      _currentCompetition!.results[resultIndex] = newResult;
    } else {
      _undoStack.add(RaceResult(
        participantId: participant.id,
        raceNumber: _currentRaceIndex,
        result: '',
      ));
      _currentCompetition!.results.add(newResult);
    }

    _redoStack = [];
    await _moveToNextParticipant();
  }

  /// Move para o próximo participante
  Future<void> _moveToNextParticipant() async {
    if (_currentCompetition == null) return;

    _currentParticipantIndex++;
    if (_currentParticipantIndex >= _currentCompetition!.participants.length) {
      _currentParticipantIndex = 0;
      await _moveToNextRace();
    }

    await updateCurrentCompetition();
    notifyListeners();
  }

  /// Move para a próxima armada
  Future<void> _moveToNextRace() async {
    _currentRaceIndex++;
    if (_currentRaceIndex >= _currentCompetition!.totalRaces) {
      _currentRaceIndex = _currentCompetition!.totalRaces - 1;
    }
  }

  /// Desfaz a última ação
  Future<void> undo() async {
    if (_undoStack.isEmpty || _currentCompetition == null) return;

    final lastAction = _undoStack.removeLast();
    
    // Move o resultado atual para o redo stack
    final currentIndex = _currentCompetition!.results.indexWhere(
      (r) => r.participantId == lastAction.participantId && 
              r.raceNumber == lastAction.raceNumber,
    );

    if (currentIndex != -1) {
      _redoStack.add(_currentCompetition!.results[currentIndex]);
      _currentCompetition!.results.removeAt(currentIndex);
    }

    await updateCurrentCompetition();
    notifyListeners();
  }

  /// Refaz a última ação desfeita
  Future<void> redo() async {
    if (_redoStack.isEmpty || _currentCompetition == null) return;

    final action = _redoStack.removeLast();
    _undoStack.add(action);
    _currentCompetition!.results.add(action);

    await updateCurrentCompetition();
    notifyListeners();
  }

  /// Retorna todas as competições
  List<Competition> getAllCompetitions() {
    return _competitionBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Deleta uma competição
  Future<void> deleteCompetition(int index) async {
    await _competitionBox.deleteAt(index);
    if (_currentCompetition == null) {
      _currentCompetition = null;
    }
    notifyListeners();
  }

  /// Duplica uma competição
  Future<void> duplicateCompetition(int index, String newName) async {
    final original = _competitionBox.getAt(index);
    if (original != null) {
      final duplicate = Competition(
        name: newName,
        totalRaces: original.totalRaces,
        participants: original.participants
            .map((p) => Participant(
              name: p.name,
              number: p.number,
              order: p.order,
            ))
            .toList(),
      );
      await _competitionBox.add(duplicate);
      notifyListeners();
    }
  }

  /// Adiciona um participante
  Future<void> addParticipant(String name, [String? number]) async {
    if (_currentCompetition == null) return;

    final participant = Participant(
      name: name,
      number: number,
      order: _currentCompetition!.participants.length + 1,
    );

    _currentCompetition!.participants.add(participant);
    await updateCurrentCompetition();
    notifyListeners();
  }

  /// Atualiza um participante
  Future<void> updateParticipant(int index, String name, [String? number]) async {
    if (_currentCompetition == null) return;

    _currentCompetition!.participants[index] = Participant(
      id: _currentCompetition!.participants[index].id,
      name: name,
      number: number,
      order: _currentCompetition!.participants[index].order,
      createdAt: _currentCompetition!.participants[index].createdAt,
    );

    await updateCurrentCompetition();
    notifyListeners();
  }

  /// Remove um participante
  Future<void> removeParticipant(int index) async {
    if (_currentCompetition == null) return;

    _currentCompetition!.participants.removeAt(index);
    // Remove também todos os resultados desse participante
    _currentCompetition!.results.removeWhere(
      (r) => r.participantId == _currentCompetition!.participants[index].id,
    );

    await updateCurrentCompetition();
    notifyListeners();
  }

  /// Retorna o resultado para um participante e armada
  String? getResult(String participantId, int raceNumber) {
    if (_currentCompetition == null) return null;

    try {
      final result = _currentCompetition!.results.firstWhere(
        (r) => r.participantId == participantId && r.raceNumber == raceNumber,
      );
      return result.result.isEmpty ? null : result.result;
    } catch (e) {
      return null;
    }
  }

  /// Retorna estatísticas
  Map<String, dynamic> getStatistics() {
    if (_currentCompetition == null) return {};

    int pCount = 0;
    int nCount = 0;

    for (var result in _currentCompetition!.results) {
      if (result.result == 'P') pCount++;
      if (result.result == 'N') nCount++;
    }

    final total = pCount + nCount;
    final pPercentage = total > 0 ? (pCount / total * 100).toStringAsFixed(1) : '0.0';
    final nPercentage = total > 0 ? (nCount / total * 100).toStringAsFixed(1) : '0.0';

    return {
      'p_count': pCount,
      'n_count': nCount,
      'p_percentage': pPercentage,
      'n_percentage': nPercentage,
      'total': total,
    };
  }
}