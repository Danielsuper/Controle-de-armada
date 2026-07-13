import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';

/// Modelo de Competição
@HiveType(typeId: 0)
class Competition extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late int totalRaces;

  @HiveField(4)
  late List<Participant> participants;

  @HiveField(5)
  late List<RaceResult> results;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late DateTime updatedAt;

  Competition({
    String? id,
    required this.name,
    DateTime? date,
    required this.totalRaces,
    List<Participant>? participants,
    List<RaceResult>? results,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.id = id ?? const Uuid().v4();
    this.date = date ?? DateTime.now();
    this.participants = participants ?? [];
    this.results = results ?? [];
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  /// Atualiza o timestamp de modificação
  void updateTimestamp() {
    updatedAt = DateTime.now();
  }

  /// Cria uma cópia da competição
  Competition copyWith({
    String? id,
    String? name,
    DateTime? date,
    int? totalRaces,
    List<Participant>? participants,
    List<RaceResult>? results,
  }) {
    return Competition(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      totalRaces: totalRaces ?? this.totalRaces,
      participants: participants ?? this.participants,
      results: results ?? this.results,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// Modelo de Participante
@HiveType(typeId: 1)
class Participant extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String? number;

  @HiveField(3)
  late int order;

  @HiveField(4)
  late DateTime createdAt;

  Participant({
    String? id,
    required this.name,
    this.number,
    required this.order,
    DateTime? createdAt,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
  }

  /// Cria uma cópia do participante
  Participant copyWith({
    String? name,
    String? number,
    int? order,
  }) {
    return Participant(
      id: id,
      name: name ?? this.name,
      number: number ?? this.number,
      order: order ?? this.order,
      createdAt: createdAt,
    );
  }
}

/// Modelo de Resultado de Armada
@HiveType(typeId: 2)
class RaceResult extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String participantId;

  @HiveField(2)
  late int raceNumber;

  @HiveField(3)
  late String result; // 'P' ou 'N'

  @HiveField(4)
  late DateTime timestamp;

  RaceResult({
    String? id,
    required this.participantId,
    required this.raceNumber,
    required this.result,
    DateTime? timestamp,
  }) {
    this.id = id ?? const Uuid().v4();
    this.timestamp = timestamp ?? DateTime.now();
  }

  /// Cria uma cópia do resultado
  RaceResult copyWith({
    String? participantId,
    int? raceNumber,
    String? result,
  }) {
    return RaceResult(
      id: id,
      participantId: participantId ?? this.participantId,
      raceNumber: raceNumber ?? this.raceNumber,
      result: result ?? this.result,
      timestamp: DateTime.now(),
    );
  }
}
