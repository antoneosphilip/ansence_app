class GetAllAbsenceModel {
  final Student student;
   bool attendant;

  GetAllAbsenceModel({required this.student, required this.attendant});

  factory GetAllAbsenceModel.fromJson(Map<String, dynamic> json) {
    return GetAllAbsenceModel(
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
  int? id;
  String? studentName;
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
  List<Absences>? absences;

  Student({
    this.id,
    this.studentName,
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
    this.absences,
  });

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentName = json['name'];
    studentClass = json['class'];
    level = json['level'];
    gender = json['gender'];
    birthDate = json['birthDate'];
    age = json['age'];
    mamPhone = json['mamPhone'];
    dadPhone = json['dadPhone'];
    studPhone = json['studPhone'];
    shift = json['shift'];
    numberOfAbsences = json['numberOfAbsences'];
    notes = json['notes'];

    // Initialize the absences list only if there's data in json['absences']
    if (json['absences'] != null) {
      absences = [];
      json['absences'].forEach((v) {
        absences!.add(Absences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = studentName;
    data['class'] = studentClass;
    data['level'] = level;
    data['gender'] = gender;
    data['birthDate'] = birthDate;
    data['age'] = age;
    data['mamPhone'] = mamPhone;
    data['dadPhone'] = dadPhone;
    data['studPhone'] = studPhone;
    data['shift'] = shift;
    data['numberOfAbsences'] = numberOfAbsences;
    data['notes'] = notes;

    if (absences != null) {
      data['absences'] = absences!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Absences {
  int? id;
  int? studentId;
  String? absenceDate;
  String? absenceReason;
  bool? attendant;

  Absences({
    this.id,
    this.studentId,
    this.absenceDate,
    this.absenceReason,
    this.attendant,
  });

  Absences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['studentId'];
    absenceDate = json['absenceDate'];
    absenceReason = json['absenceReason'];
    attendant = json['attendant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['studentId'] = studentId;
    data['absenceDate'] = absenceDate;
    data['absenceReason'] = absenceReason;
    data['attendant'] = attendant;
    return data;
  }
}
