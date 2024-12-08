// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentDataAdapter extends TypeAdapter<StudentData> {
  @override
  final int typeId = 2;

  @override
  StudentData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentData(
      id: fields[0] as int,
      name: fields[1] as String,
      studentClass: fields[2] as int,
      level: fields[3] as int,
      gender: fields[4] as int,
      birthDate: fields[5] as String?,
      age: fields[6] as int?,
      mamPhone: fields[7] as String?,
      dadPhone: fields[8] as String?,
      studPhone: fields[9] as String?,
      shift: fields[10] as int,
      numberOfAbsences: fields[11] as int,
      notes: fields[12] as String,
      absences: (fields[13] as List).cast<Absence>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.studentClass)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.birthDate)
      ..writeByte(6)
      ..write(obj.age)
      ..writeByte(7)
      ..write(obj.mamPhone)
      ..writeByte(8)
      ..write(obj.dadPhone)
      ..writeByte(9)
      ..write(obj.studPhone)
      ..writeByte(10)
      ..write(obj.shift)
      ..writeByte(11)
      ..write(obj.numberOfAbsences)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.absences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
