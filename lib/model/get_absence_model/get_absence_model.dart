import 'package:summer_school_app/model/get_missing_student_model/get_missing_student_model.dart';

class StudentAbsenceModel {
  final Student student;
  bool attendant;

  StudentAbsenceModel({
    required this.student,
    required this.attendant,
  });

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
  String? id;
  String? studentName;
  String? classId;
  int? studentClass;
  int? level;
  int? gender;
  String? birthDate;
  int? age;
  String? mamPhone;
  String? dadPhone;
  String? studPhone;
  int? shift;
  int? numberOfAbsences;
  String? notes;
  String? profileImage;
  int? state;
  List<Absence>? absences;

  Student({
    this.id,
    this.studentName,
    this.classId,
    this.studentClass,
    this.level,
    this.gender,
    this.birthDate,
    this.age,
    this.mamPhone,
    this.dadPhone,
    this.studPhone,
    this.shift,
    this.numberOfAbsences,
    this.notes,
    this.state,
    this.profileImage,
    this.absences,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentName: json['name'],
      classId: json['classId'],
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
      state: json['state'],
      profileImage: json['profileImage'],
      absences: (json['absences'] as List<dynamic>?)
          ?.map((e) => Absence.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': studentName,
      'classId': classId,
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
      'state': state,
      'profileImage': profileImage,
      'absences': absences?.map((e) => e.toJson()).toList(),
    };
  }
}

