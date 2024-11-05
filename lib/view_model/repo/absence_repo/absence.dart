import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:summer_school_app/core/networking/api_error_handler.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';

import '../../../model/get_absence_model/get_absence_model.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../../utility/database/network/end_points.dart';

class AbsenceRepo {

  Future<Either<ErrorHandler, List<StudentAbsenceModel>>> getAbsence(
      {required int id}) async {
    try {
      final response =
      await DioHelper.getData(url: EndPoint.getStudentAbsence(id));
      List<dynamic> jsonData = response.data;
      return Right(jsonData.map((item) => StudentAbsenceModel.fromJson(item)).toList());
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
}
