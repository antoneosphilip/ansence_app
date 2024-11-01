import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ApiErrorModel {
   String? message;
   int? code;

  ApiErrorModel({
    required this.message,
    this.code,
  });

   ApiErrorModel.fromJson(Map<String, dynamic> json){
     message=json['message'];
     code=json['code'];
   }

}