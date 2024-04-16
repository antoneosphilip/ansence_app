class VerifyEmailModel {
  Null? data;
  String? message;
  String? type;
  int? code;

  VerifyEmailModel({this.data, this.message, this.type, this.code});

  VerifyEmailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    type = json['type'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    data['type'] = this.type;
    data['code'] = this.code;
    return data;
  }
}