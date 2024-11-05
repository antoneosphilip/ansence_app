class StudentAbsenceModel {
  final Student student;
   bool attendant;

  StudentAbsenceModel({required this.student, required this.attendant});

  factory StudentAbsenceModel.fromJson(Map<String, dynamic> json) {
    return StudentAbsenceModel(
      student: Student.fromJson(json['student']),
      attendant: json['attendant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student': student.toJson(),
      'attendant': attendant,
    };
  }
}

class Student {
  final int id;
  final String name;
  final int studentClass;
  final int level;
  final int gender;
  final String birthDate;
  final int age;
  final String? mamPhone;
  final String? dadPhone;
  final String? studPhone;
  final int shift;
  final int numberOfAbsences;
  final String notes;
  final List<Absence> absences;

  Student({
    required this.id,
    required this.name,
    required this.studentClass,
    required this.level,
    required this.gender,
    required this.birthDate,
    required this.age,
    this.mamPhone,
    this.dadPhone,
    this.studPhone,
    required this.shift,
    required this.numberOfAbsences,
    required this.notes,
    required this.absences,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      studentClass: json['class'],
      level: json['level'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      age: json['age'],
      mamPhone: json['mamPhone'],
      dadPhone: json['dadPhone'],
      studPhone: json['studPhone'],
      shift: json['shift'],
      numberOfAbsences: json['numberOfAbsences'],
      notes: json['notes'],
      absences: (json['absences'] as List)
          .map((item) => Absence.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'class': studentClass,
      'level': level,
      'gender': gender,
      'birthDate': birthDate,
      'age': age,
      'mamPhone': mamPhone,
      'dadPhone': dadPhone,
      'studPhone': studPhone,
      'shift': shift,
      'numberOfAbsences': numberOfAbsences,
      'notes': notes,
      'absences': absences.map((absence) => absence.toJson()).toList(),
    };
  }
}

class Absence {
  final int id;
  final int studentId;
  final String absenceDate;
  final String absenceReason;
   bool attendant;

  Absence({
    required this.id,
    required this.studentId,
    required this.absenceDate,
    required this.absenceReason,
    required this.attendant,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      studentId: json['studentId'],
      absenceDate: json['absenceDate'],
      absenceReason: json['absenceReason'],
      attendant: json['attendant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'absenceDate': absenceDate,
      'absenceReason': absenceReason,
      'attendant': attendant,
    };
  }
}
