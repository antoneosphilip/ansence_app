import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:summer_school_app/core/networking/api_error_handler.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';

import '../../../model/get_absence_model/get_absence_model.dart';

class AbsenceRepo {
  Future<Either<ErrorHandler, GetAbsenceModel>> getAbsence() async {
    try {
      final response = await DioHelper.getData(url: '');
      return Right(GetAbsenceModel.fromJson(response.data));
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

