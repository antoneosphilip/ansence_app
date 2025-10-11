import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summer_school_app/core/networking/api_error_handler.dart';
import 'package:summer_school_app/utility/database/local/cache_helper.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';

import '../../../model/get_absence_model/get_absence_model.dart';
import '../../../model/get_absence_model/get_capacity.dart';
import '../../../model/get_absence_model/get_members_model.dart';
import '../../../model/get_missing_student_model/get_missing_classes.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../../utility/database/network/end_points.dart';

class AbsenceRepo {

  Future<Either<ErrorHandler, List<Student>>> getAbsence(
      {required int id}) async {
    try {
      final response =
      await DioHelper.getData(url: EndPoint.getStudentAbsence(id));
      List<dynamic> jsonData = response.data;
      return Right(jsonData.map((item) => Student.fromJson(item)).toList());
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
  Future<Either<ErrorHandler, NumbersModel>> getClassesNumber(
      {required String id}) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoint.getClassesNumber,
        queryParameters: {'servantId': CacheHelper.getDataString(key: 'id')},
      );

      print("response.data = ${response.data}");

      if (response.data == null) {
        throw Exception("Server returned null data");
      }

      if (response.data is! List) {
        throw Exception("Expected a List but got ${response.data.runtimeType}");
      }

      final jsonData = response.data as List<dynamic>;
      print("jsonDataaaaa $jsonData");

      return Right(NumbersModel.fromJson(jsonData));
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler, Response>> updateStudentAbsence(
      {
        required UpdateAbsenceStudentBody updateAbsenceStudentBody}) async {
    try {
      final response =
      await DioHelper.putData(url: EndPoint.updateStudentAbsence(updateAbsenceStudentBody.id!),
          data: {
            'Id': updateAbsenceStudentBody.id,
            'StudentId': updateAbsenceStudentBody.studentId,
            'AbsenceDate': updateAbsenceStudentBody.absenceDate,
            'AbsenceReason': updateAbsenceStudentBody.absenceReason,
            'attendant': updateAbsenceStudentBody.attendant,
          });

      return Right(response);
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("sucess${e}");

      return Left(ErrorHandler.handle(e));
    }
  }


  Future<Either<ErrorHandler, MissingClasses>> checkMissingStudents(
      {
        required String servantId}) async {
    try {
      final response =
      await DioHelper.getData(url: EndPoint.checkMissingClasses,queryParameters: {'servantId':CacheHelper.getDataString(key: 'id')});
      return Right(MissingClasses.fromJson(response.data));
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      print("sucess${e}");

      return Left(ErrorHandler.handle(e));
    }
  }
  Future<Either<ErrorHandler, List<Student>>> getAllAbsence(
      ) async {
    try {
      final response =
      await DioHelper.getData(url: EndPoint.getAllAbsence);
      List<dynamic> jsonData = response.data;
      return Right(jsonData.map((item) => Student.fromJson(item)).toList());
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler, List<Student>>> sendNotification(
      ) async {
    try {
      final response =
      await DioHelper.postData(url: EndPoint.getAllAbsence, data: {

      });
      List<dynamic> jsonData = response.data;
      return Right(jsonData.map((item) => Student.fromJson(item)).toList());
    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler, ClassStatisticsResponse>> getCapacities({
    required String id,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoint.getCapacity,
        queryParameters: {'servantId': id},
      );
      print("responseeeeeeeeeee ${response.data}");

        final List<dynamic> dataList = response.data;
        final statsResponse = ClassStatisticsResponse.fromJson(dataList);
        print("sucessss");
        return Right(statsResponse);

    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response?.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      debugPrint("Error parsing capacity data: $e");
      return Left(ErrorHandler.handle(e));
    }
  }



}
