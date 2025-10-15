import '../get_absence_model/get_absence_model.dart';

class GetMissingStudentModelAbsenceModel {
  final GetMissingStudentModel student;
  final bool alhanAbsence;
  final bool copticAbsence;
  final bool tacsAbsence;

  GetMissingStudentModelAbsenceModel({
    required this.student,
    required this.alhanAbsence,
    required this.copticAbsence,
    required this.tacsAbsence,
  });

  factory GetMissingStudentModelAbsenceModel.fromJson(Map<String, dynamic> json) {
    return GetMissingStudentModelAbsenceModel(
      student: GetMissingStudentModel.fromJson(json['student']),
      alhanAbsence: json['alhanAbsence'] ?? false,
      copticAbsence: json['copticAbsence'] ?? false,
      tacsAbsence: json['tacsAbsence'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student': student.toJson(),
      'alhanAbsence': alhanAbsence,
      'copticAbsence': copticAbsence,
      'tacsAbsence': tacsAbsence,
    };
  }
}

class GetMissingStudentModel {
  final String id;
  final String studentName;
  final String classId;
  final int? studentClass;
  final int gender;
  final String birthDate;
  final int age;
  final String? mamPhone;
  final String? dadPhone;
  final String? studPhone;
  final int numberOfAbsences;
  final String? notes;
  final int state;
  final String? profileImage;
  final List<Absence> absences;

  GetMissingStudentModel({
    required this.id,
    required this.studentName,
    required this.classId,
    required this.gender,
    required this.birthDate,
    required this.age,
    this.mamPhone,
    this.dadPhone,
    this.studPhone,
    required this.numberOfAbsences,
    this.notes,
    required this.state,
    this.profileImage,
    required this.absences,
    this.studentClass,
  });

  factory GetMissingStudentModel.fromJson(Map<String, dynamic> json) {
    return GetMissingStudentModel(
      studentClass: json['class'] is int ? json['class'] : null,
      id: json['id'] ?? '',
      studentName: json['name'] ?? '',
      classId: json['classId'] ?? '',
      gender: json['gender'] ?? 0,
      birthDate: json['birthDate'] ?? '',
      age: json['age'] ?? 0,
      mamPhone: json['mamPhone']?.toString(),
      dadPhone: json['dadPhone']?.toString(),
      studPhone: json['studPhone']?.toString(),
      numberOfAbsences: json['numberOfAbsences'] ?? 0,
      notes: json['notes'],
      state: json['state'] ?? 0,
      profileImage: json['profileImage'],
      absences: (json['absences'] as List<dynamic>?)
          ?.map((e) => Absence.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': studentName,
      'classId': classId,
      'gender': gender,
      'birthDate': birthDate,
      'age': age,
      'mamPhone': mamPhone,
      'dadPhone': dadPhone,
      'studPhone': studPhone,
      'numberOfAbsences': numberOfAbsences,
      'notes': notes,
      'state': state,
      'profileImage': profileImage,
      'absences': absences.map((e) => e.toJson()).toList(),
    };
  }
}

class Absence {
  final String id;
  final String studentId;
  final String absenceDate;
  final String? absenceReason;
  final bool alhanAttendant;
  final bool copticAttendant;
  final bool tacsAttendant;
  final bool attendant;
  final StudentAbsence? student;

  Absence({
    required this.id,
    required this.studentId,
    required this.absenceDate,
    this.absenceReason,
    required this.alhanAttendant,
    required this.copticAttendant,
    required this.tacsAttendant,
    required this.attendant,
    this.student,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      absenceDate: json['absenceDate'] ?? '',
      absenceReason: json['absenceReason'],
      alhanAttendant: json['alhanAttendant'] ?? false,
      copticAttendant: json['copticAttendant'] ?? false,
      tacsAttendant: json['tacsAttendant'] ?? false,
      attendant: json['attendant'] ?? false,
      student: json['student'] != null ? StudentAbsence.fromJson(json['student']) : null, // ← هنا التحويل
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'absenceDate': absenceDate,
      'absenceReason': absenceReason,
      'alhanAttendant': alhanAttendant,
      'copticAttendant': copticAttendant,
      'tacsAttendant': tacsAttendant,
      'attendant': attendant,
      'student': student?.toJson(), // ← أضفناها
    };
  }

  Absence copyWith({
    String? id,
    String? studentId,
    String? absenceDate,
    String? absenceReason,
    bool? alhanAttendant,
    bool? copticAttendant,
    bool? tacsAttendant,
    bool? attendant,
    StudentAbsence? student,
  }) {
    return Absence(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      absenceDate: absenceDate ?? this.absenceDate,
      absenceReason: absenceReason ?? this.absenceReason,
      alhanAttendant: alhanAttendant ?? this.alhanAttendant,
      copticAttendant: copticAttendant ?? this.copticAttendant,
      tacsAttendant: tacsAttendant ?? this.tacsAttendant,
      attendant: attendant ?? this.attendant,
      student: student ?? this.student,
    );
  }
}


class StudentAbsence {
  final String id;
  final String name;
  final String? classId;
  final String? profileImage;

  StudentAbsence({
    required this.id,
    required this.name,
    this.classId,
    this.profileImage,
  });

  factory StudentAbsence.fromJson(Map<String, dynamic> json) {
    return StudentAbsence(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      classId: json['classId'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'classId': classId,
      'profileImage': profileImage,
    };
  }
}
