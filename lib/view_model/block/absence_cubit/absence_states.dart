abstract class AbsenceStates {}

class AbsenceInitialState extends AbsenceStates {}

// Get Absence States
class GetAbsenceLoadingState extends AbsenceStates {}

class GetAbsenceSuccessState extends AbsenceStates {}

class GetAbsenceErrorState extends AbsenceStates {
  final String error;
  GetAbsenceErrorState(this.error);
}

// Get All Absence States
class GetAllAbsenceLoadingState extends AbsenceStates {}

class GetAllAbsenceSuccessState extends AbsenceStates {}

class GetAllAbsenceErrorState extends AbsenceStates {
  final String error;
  GetAllAbsenceErrorState(this.error);
}

// Update Student Absence States
class UpdateStudentAbsenceLoadingState extends AbsenceStates {}

class UpdateStudentAbsenceSuccessState extends AbsenceStates {}

class UpdateStudentAbsenceErrorState extends AbsenceStates {
  final String error;
  final String studentId;
  UpdateStudentAbsenceErrorState(this.error, this.studentId);
}

// Get Capacity States
class GetCapacityLoadingState extends AbsenceStates {}

class GetCapacitySuccessState extends AbsenceStates {}

class GetCapacityErrorState extends AbsenceStates {
  final String error;
  GetCapacityErrorState(this.error);
}

// Get Classes Number States
class GetClassesNumberLoadingState extends AbsenceStates {}

class GetClassesNumberSuccessState extends AbsenceStates {}

class GetClassesNumberErrorState extends AbsenceStates {
  final String error;
  GetClassesNumberErrorState(this.error);
}

// Get Missing Classes States
class GetMissingClassesLoadingState extends AbsenceStates {}

class GetMissingClassesSuccessState extends AbsenceStates {}

class GetMissingClassesErrorState extends AbsenceStates {
  final String error;
  GetMissingClassesErrorState(this.error);
}

// Offline States
class OfflineAbsenceStudentsState extends AbsenceStates {}

class ChangeAbsenceLength extends AbsenceStates {}

// Statistics States
class StatisticsUpdatedState extends AbsenceStates {}

class LocalStatisticsLoadedState extends AbsenceStates {}
class UpdateStatisticsState extends AbsenceStates {}