abstract class MissingStates{}
class MissingInitialState extends MissingStates{}


/////       Get Missing       /////////////
class GetMissingStudentLoadingState extends MissingStates{}
class GetMissingStudentErrorState extends MissingStates{
  final String error;
  GetMissingStudentErrorState(this.error);
}
class GetMissingStudentSuccessState extends MissingStates{}

class UpdateStudentMissingLoadingState extends MissingStates{}
class UpdateStudentMissingErrorState extends MissingStates{
  final String error;
  final int studentId;
  UpdateStudentMissingErrorState(this.error, this.studentId, );
}
class UpdateStudentMissingSuccessState extends MissingStates{}


class CompleteAllStudentMissingSuccessState extends MissingStates{}


