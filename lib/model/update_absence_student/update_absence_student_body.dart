class UpdateAbsenceStudentBody {
   String? id;
  String? studentId;
  String? absenceDate;
  String ?absenceReason;
  bool? attendant;

  UpdateAbsenceStudentBody(
      {required this.id,
        this.studentId,
        this.absenceDate,
        this.absenceReason,
        this.attendant});

  UpdateAbsenceStudentBody.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    studentId = json['StudentId'];
    absenceDate = json['AbsenceDate'];
    absenceReason = json['AbsenceReason'];
    attendant = json['attendant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['StudentId'] = this.studentId;
    data['AbsenceDate'] = this.absenceDate;
    data['AbsenceReason'] = this.absenceReason;
    data['attendant'] = this.attendant;
    return data;
  }
}