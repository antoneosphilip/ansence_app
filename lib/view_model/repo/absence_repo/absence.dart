import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:summer_school_app/core/networking/api_error_handler.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';

import '../../../core/networking/api_constants.dart';
import '../../../model/get_absence_model/get_absence_model.dart';
import '../../../utility/database/network/end_points.dart';

class AbsenceRepo {
  List<StudentAbsenceModel> absenceList = [];

  Future<Either<ErrorHandler, List<StudentAbsenceModel>>> getAbsence({required int id}) async {
    try {
      final response = await DioHelper.getData(url: EndPoint.getStudentAbsence(id));
      print("Ssssssssssss");
      absenceList.clear();
      for (var item in response.data) {
        absenceList.add(StudentAbsenceModel.fromJson(item));
      }
      return Right(absenceList);

    } on DioException catch (e) {
      debugPrint("-------------Response Data----------------");
      debugPrint(e.response!.data.toString());
      debugPrint("-------------Response Data----------------");
      return Left(ErrorHandler.handle(e));
    }
    catch(e)
    {
      return Left(ErrorHandler.handle(e));
    }
  }
}

