// States للـ Cubit
abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class SignUpLoadingState extends AuthStates {}

class SignUpSuccessState extends AuthStates {}

class SignUpErrorState extends AuthStates {
  final String error;

  SignUpErrorState(this.error);
}



class ChangeClassState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState(this.error);
}

class SendEmailLoadingState extends AuthStates {}

class SendEmailSuccessState extends AuthStates {}

class SendEmailErrorState extends AuthStates {
  final String error;

  SendEmailErrorState(this.error);
}

class CheckOtpLoadingState extends AuthStates {}

class CheckOtpSuccessState extends AuthStates {}

class CheckOtpErrorState extends AuthStates {
  final String error;

  CheckOtpErrorState(this.error);
}

class ChangePasswordLoadingState extends AuthStates {}

class ChangePasswordSuccessState extends AuthStates {}

class ChangePasswordErrorState extends AuthStates {
  final String error;

  ChangePasswordErrorState(this.error);
}