import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';

import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../repo/absence_repo/absence.dart';
import 'absence_states.dart';

class AbsenceCubit extends Cubit<AbsenceStates> {
  AbsenceRepo absenceRepo;

  AbsenceCubit(this.absenceRepo) : super(AbsenceInitialState());

  static AbsenceCubit get(context) => BlocProvider.of<AbsenceCubit>(context);
  List<StudentAbsenceModel> studentAbsenceModel = [];

  Future<void> getAbsence({required int id}) async {
    emit(GetAbsenceLoadingState());
    final response = await absenceRepo.getAbsence(id: id);
    response.fold(
      (l) {
        emit(GetAbsenceErrorState(l.apiErrorModel.message.toString()));
      },
      (r) {
        for (int i = 0; i < r.length; i++) {
          print(r[i].student.absences);
        }
        studentAbsenceModel.clear();
        studentAbsenceModel.addAll(r);
        emit(GetAbsenceSuccessState());
      },
    );
  }

  Future<void> updateStudentAbsence(
      {
      required UpdateAbsenceStudentBody updateAbsenceStudentBody}) async {
    emit(UpdateStudentAbsenceLoadingState());
    final response = await absenceRepo.updateStudentAbsence(
         updateAbsenceStudentBody: updateAbsenceStudentBody);
    response.fold(
      (l) {
        print("errorrrrr");
        emit(
            UpdateStudentAbsenceErrorState(l.apiErrorModel.message.toString(),updateAbsenceStudentBody.studentId!));
      },
      (r) {
        emit(UpdateStudentAbsenceSuccessState());
      },
    );
  }
}
