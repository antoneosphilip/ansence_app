// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbsenceAdapter extends TypeAdapter<Absence> {
  @override
  final int typeId = 1;

  @override
  Absence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Absence(
      id: fields[0] as String,
      studentId: fields[1] as String,
      absenceDate: fields[2] as String,
      absenceReason: fields[3] as String,
      attendant: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Absence obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.absenceDate)
      ..writeByte(3)
      ..write(obj.absenceReason)
      ..writeByte(4)
      ..write(obj.attendant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbsenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
