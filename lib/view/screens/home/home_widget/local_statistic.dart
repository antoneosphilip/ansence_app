import 'package:hive/hive.dart';

part 'local_statistic.g.dart';

@HiveType(typeId: 0)
class ClassStatistics extends HiveObject {
  @HiveField(0)
  final int classNumber;

  @HiveField(1)
  final int capacity;

  @HiveField(2)
  final int numberOfAttendants;

  @HiveField(3)
  final int numberOfAbsents;

  ClassStatistics({required this.classNumber, required this.capacity, required this.numberOfAttendants, required this.numberOfAbsents});
}