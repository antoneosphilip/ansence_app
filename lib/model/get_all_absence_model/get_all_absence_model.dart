import '../get_absence_model/get_absence_model.dart';

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
