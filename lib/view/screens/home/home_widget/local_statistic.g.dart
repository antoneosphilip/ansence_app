// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_statistic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassStatisticsAdapter extends TypeAdapter<ClassStatistics> {
  @override
  final int typeId = 0;

  @override
  ClassStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassStatistics(
      classNumber: fields[0] as int,
      capacity: fields[1] as int,
      numberOfAttendants: fields[2] as int,
      numberOfAbsents: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ClassStatistics obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.classNumber)
      ..writeByte(1)
      ..write(obj.capacity)
      ..writeByte(2)
      ..write(obj.numberOfAttendants)
      ..writeByte(3)
      ..write(obj.numberOfAbsents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
