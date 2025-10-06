import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:summer_school_app/core/networking/api_error_handler.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';

import '../../../model/auth_response/sign_in_body.dart';
import '../../../model/auth_response/sign_up_body.dart';
import '../../../model/get_absence_model/get_absence_model.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../../utility/database/network/end_points.dart';

class AuthRepo {

  Future<Either<ErrorHandler,String>>signUp(
      {required RegisterBody registerBody}) async {
    try {
      print("Body => ${registerBody.toJson()}");
      final response =
      await DioHelper.postData(url: EndPoint.signup,data: registerBody.toJson());
      print("responseee ${response.data}");

      return const Right("Sing up Successfully");
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("errorrr ${e.toString()}");
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler,String>>signIn(
      {required LoginBody loginBody}) async {
    try {
      print("Body => ${loginBody.toJson()}");
      final response =
      await DioHelper.postData(url: EndPoint.signIn,data: loginBody.toJson());
      print("responseee ${response.data}");

      return const Right("Sing up Successfully");
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("errorrr ${e.toString()}");
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler,String>>sendEmail(
      {required String email}) async {
    try {
      final response =
      await DioHelper.postData(url: EndPoint.sendEmail,data: {

      },query: {'email':email});
      print("responseee ${response.data}");

      return const Right("Sing up Successfully");
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("errorrr ${e.toString()}");
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler,String>>checkOtp(
      {required String email,required String otp}) async {
    try {
      final response =
      await DioHelper.postData(url: EndPoint.sendEmail,data: {},query: {'email':email,'otp':otp});
      print("responseee ${response.data}");

      return const Right("Sing up Successfully");
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("errorrr ${e.toString()}");
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler,String>>changePassword(
      {required String email,required String password,required String confirmPassword}) async {
    try {
      final response =
      await DioHelper.postData(url: EndPoint.changePassword,data: {},query: {'email':email,'password':password,'confirmPassword':confirmPassword});
      print("responseee ${response.data}");

      return const Right("Sing up Successfully");
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("errorrr ${e.toString()}");
      return Left(ErrorHandler.handle(e));
    }
  }
}
