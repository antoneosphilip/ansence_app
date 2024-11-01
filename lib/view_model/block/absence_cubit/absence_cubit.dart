import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/absence_repo/absence.dart';
import 'absence_states.dart';

class AbsenceCubit extends Cubit<AbsenceStates> {
  AbsenceRepo? absenceRepo;

  AbsenceCubit() : super(AbsenceInitialState());

  Future<void> getAbsence() async {
    emit(GetAbsenceLoadingState());
    final response = await absenceRepo?.getAbsence();
    response?.fold(
      (l) {
        emit(GetAbsenceErrorState(l.apiErrorModel.message.toString()));
      },
      (r) {
        emit(GetAbsenceSuccessState());
      },
    );
  }
}
