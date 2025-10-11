import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/get_missing_student_model/get_missing_student_model.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../repo/missing_repo/missing_repo.dart';
import 'missing_states.dart';

class MissingCubit extends Cubit<MissingStates> {
  MissingRepo missingRepo;

  MissingCubit(this.missingRepo) : super(MissingInitialState());

  static MissingCubit get(context) => BlocProvider.of<MissingCubit>(context);
  List<GetMissingStudentModelAbsenceModel> studentMissingModelList = [];
  final reasonTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> getAbsenceMissing({required int id}) async {
    emit(GetMissingStudentLoadingState());
    final response = await missingRepo.getAbsenceMissing(id: id);
    response.fold(
      (l) {
        print(l.apiErrorModel.message.toString());
        emit(GetMissingStudentErrorState(l.apiErrorModel.message.toString()));
      },
      (r) {
        // for (int i = 0; i < r.length; i++) {
        //   print(r[i].student.absences);
        // }
        print("sucessssssssssss gettt;");
        studentMissingModelList.clear();
        studentMissingModelList.addAll(r);


        emit(GetMissingStudentSuccessState());
      },
    );
  }

  Future<void> makeDirectCall(String phoneNumber) async {
    bool? callSucceeded =
        await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (callSucceeded == null || !callSucceeded) {
      showFlutterToast(
          message: "حدث خطأ في الاتصال حاول لاحقا", state: ToastState.ERROR);
    }
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    final whatsappUrl = "https://wa.me/$phoneNumber";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      showFlutterToast(
          message: "Could not open WhatsApp", state: ToastState.ERROR);
    }
  }

  Future<void> updateStudentMissing(
      {required UpdateAbsenceStudentBody updateAbsenceStudentBody}) async {
    emit(UpdateStudentMissingLoadingState());
    final response = await missingRepo.updateStudentMissing(
        updateAbsenceStudentBody: updateAbsenceStudentBody);
    response.fold(
      (l) {
        print("errror");
        emit(UpdateStudentMissingErrorState(l.apiErrorModel.message.toString(),
            updateAbsenceStudentBody.studentId!));
      },
      (r) {
        print("lastttttttttttttttttt${studentMissingModelList.last.student.id}");
        for (var element in studentMissingModelList) {
          if (element.student.id == updateAbsenceStudentBody.studentId) {
            final lastAbsence = element.student.absences!.last.copyWith(
              absenceReason: updateAbsenceStudentBody.absenceReason,
            );
            element.student.absences![element.student.absences!.length - 1] = lastAbsence;
          }
        }

        emit(UpdateStudentMissingSuccessState());
      },
    );
  }

  bool isDoneAbsence = false;
  bool isShowFirstOne=false;
  bool checkIfDoneAllAbsence(
      {required GetMissingStudentModelAbsenceModel getMissingStudentModel}) {
    for (var element in studentMissingModelList) {
      if(element.student.absences!.last.absenceReason!.isNotEmpty){
        isDoneAbsence=true;
      }
      else{
        isDoneAbsence=false;
        break;
      }
    }print("isdONNEE$isDoneAbsence");
    if(isDoneAbsence&&!isShowFirstOne) {
      emit(CompleteAllStudentMissingSuccessState());
      isShowFirstOne=true;
    }
      return isDoneAbsence;
  }
}
