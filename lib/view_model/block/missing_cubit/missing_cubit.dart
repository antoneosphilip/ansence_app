import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/get_missing_student_model/get_missing_student_model.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../repo/absence_repo/absence.dart';
import '../../repo/missing_repo/missing_repo.dart';
import 'missing_states.dart';

class MissingCubit extends Cubit<MissingStates> {
  MissingRepo missingRepo;

  MissingCubit(this.missingRepo) : super(MissingInitialState());

  static MissingCubit get(context) => BlocProvider.of<MissingCubit>(context);
  List<GetMissingStudentModel> studentMissingModel = [];
  final reasonTextController=TextEditingController();
  final formKey = GlobalKey<FormState>();


  Future<void> getAbsenceMissing({required int id}) async {
    emit(GetMissingStudentLoadingState());
    final response = await missingRepo.getAbsenceMissing(id: id);
    response.fold(
      (l) {
        emit(GetMissingStudentErrorState(l.apiErrorModel.message.toString()));
      },
      (r) {
        // for (int i = 0; i < r.length; i++) {
        //   print(r[i].student.absences);
        // }
        studentMissingModel.clear();
        studentMissingModel.addAll(r);
        emit(GetMissingStudentSuccessState());
      },
    );
  }


  Future<void> makeDirectCall(String phoneNumber) async {
    bool? callSucceeded = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (callSucceeded == null || !callSucceeded) {
     showFlutterToast(message: "حدث خطأ في الاتصال حاول لاحقا", state: ToastState.ERROR);
    }
  }


  Future<void> updateStudentMissing(
      {
      required UpdateAbsenceStudentBody updateAbsenceStudentBody}) async {
    emit(UpdateStudentMissingLoadingState());
    final response = await missingRepo.updateStudentMissing(
         updateAbsenceStudentBody: updateAbsenceStudentBody);
    response.fold(
      (l) {
        print("errorrrrr");
        emit(
            UpdateStudentMissingErrorState(l.apiErrorModel.message.toString(),updateAbsenceStudentBody.studentId!));
      },
      (r) {
        emit(UpdateStudentMissingSuccessState());
      },
    );
  }
}
