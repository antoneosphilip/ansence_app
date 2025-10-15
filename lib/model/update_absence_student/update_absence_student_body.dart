import '../get_absence_model/get_absence_model.dart';

class UpdateAbsenceStudentBody {
  String? id;
  String? studentId;
  String? absenceDate;
  String? absenceReason;
  bool? alhanAttendant;
  bool? copticAttendant;
  bool? tacsAttendant;
  bool? attendant;
  Student? student;

  UpdateAbsenceStudentBody({
    this.id,
    this.studentId,
    this.absenceDate,
    this.absenceReason,
    this.alhanAttendant,
    this.copticAttendant,
    this.tacsAttendant,
    this.attendant,
    this.student,
  });

  factory UpdateAbsenceStudentBody.fromJson(Map<String, dynamic> json) {
    return UpdateAbsenceStudentBody(
      id: json['id'],
      studentId: json['studentId'],
      absenceDate: json['absenceDate'],
      absenceReason: json['absenceReason'],
      alhanAttendant: json['alhanAttendant'],
      copticAttendant: json['copticAttendant'],
      tacsAttendant: json['tacsAttendant'],
      attendant: json['attendant'],
      student: json['student'] != null ? Student.fromJson(json['student']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['studentId'] = studentId;
    data['absenceDate'] = absenceDate;
    data['absenceReason'] = absenceReason;
    data['alhanAttendant'] = alhanAttendant;
    data['copticAttendant'] = copticAttendant;
    data['tacsAttendant'] = tacsAttendant;
    data['attendant'] = attendant;
    if (student != null) {
      data['student'] = student!.toJson();
    }
    return data;
  }
}
