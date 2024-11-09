import 'package:hive/hive.dart';

part 'absence.g.dart';

@HiveType(typeId: 1)
class Absence {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int studentId;

  @HiveField(2)
  final String absenceDate;

  @HiveField(3)
  final String absenceReason;

  @HiveField(4)
  final bool attendant;

  Absence({
    required this.id,
    required this.studentId,
    required this.absenceDate,
    required this.absenceReason,
    required this.attendant,
  });
}
