// import 'dart:convert';
//
// import 'package:x_station_app/model/signup_model/signup_model.dart';
//
// import '../../../model/login_model/login_model.dart';
// import 'cache_helper.dart';
//
// class CachingDataManager {
//   CachingDataManager._();
//
//   static CachingDataManager instance = CachingDataManager._();
//
//   void cachLoginInfo(LoginModel loginModel) async {
//     await CacheHelper.put(
//         key: "loginModel", value: jsonEncode(loginModel.toJson()));
//   }
//
//   LoginModel getLoginModel() {
//     String data = CacheHelper.getDataString(key: "loginModel");
//     return LoginModel.fromJson(jsonDecode(data));
//   }
//
//   void cachRegisterInfo(SignUpModel signUpModel) async {
//     await CacheHelper.put(
//         key: "signupModel", value: jsonEncode(signUpModel.toJson()));
//   }
//
//   SignUpModel getSignUpModel() {
//     String data = CacheHelper.getDataString(key: "signupModel");
//     return SignUpModel.fromJson(jsonDecode(data));
//   }
//
// }
//
