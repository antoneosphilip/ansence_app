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
