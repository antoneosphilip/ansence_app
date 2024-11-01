class StudentAbsenceModel {
  int? id;
  String? name;
  int? classStudent;
  int? level;
  int? gender;
  String? birthDate;
  int? age;
  String ?mamPhone;
  String? dadPhone;
  String? studPhone;
  int? shift;
  int? numberOfAbsences;
  String ?notes;
  // List<Null> absences;

  StudentAbsenceModel({this.id, this.name, this.classStudent, this.level, this.gender, this.birthDate, this.age, this.mamPhone, this.dadPhone, this.studPhone, this.shift, this.numberOfAbsences, this.notes});

  StudentAbsenceModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  classStudent = json['class'];
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
  // if (json['absences'] != null) {
  //   absences = new List<Null>();
  // json['absences'].forEach((v) { absences.add(new Null.fromJson(v)); });
  // }
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['class'] = this.classStudent;
  data['level'] = this.level;
  data['gender'] = this.gender;
  data['birthDate'] = this.birthDate;
  data['age'] = this.age;
  data['mamPhone'] = this.mamPhone;
  data['dadPhone'] = this.dadPhone;
  data['studPhone'] = this.studPhone;
  data['shift'] = this.shift;
  data['numberOfAbsences'] = this.numberOfAbsences;
  data['notes'] = this.notes;
  // if (this.absences != null) {
  // data['absences'] = this.absences.map((v) => v.toJson()).toList();
  // }
  return data;
  }
}