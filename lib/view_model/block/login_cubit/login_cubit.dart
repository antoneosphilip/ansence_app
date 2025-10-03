import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/model/auth_response/sign_in_body.dart';
import 'package:summer_school_app/model/auth_response/sign_up_body.dart';

import '../../../model/auth_response/class_data.dart';
import '../../repo/auth_repo/auth.dart';
import 'login_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  List<ClassData> classes = [];
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  void addClass() {
    classes.add(ClassData());
    emit(ChangeClassState());
  }

  void removeClass(int index) {
    classes.removeAt(index);
    emit(ChangeClassState());
  }

  void updateClassNumber(int classIndex, int? classNumber) {
    if (classIndex < classes.length) {
      classes[classIndex].classNumber = classNumber;
      emit(ChangeClassState());
    }
  }

  void updateClassSubject(int classIndex, String? subject) {
    if (classIndex < classes.length) {
      classes[classIndex].subject = subject;
      emit(ChangeClassState());
    }
  }

  bool validateClasses() {
    if (classes.isEmpty) {
      return false;
    }

    for (ClassData classData in classes) {
      if (classData.classNumber == null || classData.subject == null) {
        return false;
      }
    }
    return true;
  }

  String? getClassValidationMessage() {
    if (classes.isEmpty) {
      return 'يجب إضافة فصل واحد على الأقل';
    }

    for (int i = 0; i < classes.length; i++) {
      ClassData classData = classes[i];
      if (classData.classNumber == null || classData.subject == null) {
        return 'يجب ملء بيانات الفصل ${i + 1} كاملة';
      }
    }
    return null;
  }

  RegisterBody? registerBody;
  LoginBody? loginBody;
  Map<String,int> servantClassesMap={};
  void signUp() {
    String? classValidationMessage = getClassValidationMessage();

    if (classValidationMessage != null) {
      emit(SignUpErrorState(classValidationMessage));
      return;
    }
    for(var item in classes){
      servantClassesMap[item.classNumber.toString()]=item.subject=='ألحان'?1:item.subject=='قبطي'?2:item.subject=='طقس'?3:0;
    }

    registerBody = RegisterBody(name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        phoneNumber: phoneController.text,
        servantClasses:servantClassesMap
    );
    emit(SignUpLoadingState());
    print("dataa ${registerBody?.servantClasses}");

    final response = authRepo.signUp(registerBody: registerBody!);
    response.fold((left){
      emit(SignUpErrorState(left.apiErrorModel.message.toString()));
    }, (right) {
    emit(SignUpSuccessState());
    },
    );
  }

  void login() {

    emit(LoginLoadingState());

    loginBody = LoginBody(
      password: passwordController.text,
      phoneNumber: phoneController.text
    );
    print("dataa ${registerBody?.servantClasses}");

    final response = authRepo.signIn(loginBody: loginBody!);
    response.fold((left){
      emit(LoginErrorState(left.apiErrorModel.message.toString()));
    }, (right) {
      emit(LoginSuccessState());
    },
    );
  }
  // @override
  // void dispose() {
  //   animationController.dispose();
  //   nameController.dispose();
  //   phoneController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  //   super.dispose();
  // }
}

