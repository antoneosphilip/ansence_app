import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_school_app/model/auth_response/sign_in_body.dart';
import 'package:summer_school_app/model/auth_response/sign_up_body.dart';

import '../../../model/auth_response/class_data.dart';
import '../../../model/auth_response/sign_in_Response.dart';
import '../../../utility/database/local/cache_helper.dart';
import '../../repo/auth_repo/auth.dart';
import 'login_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  List<ClassData> classes = [];
  final formKey = GlobalKey<FormState>();
  final formKeyForget = GlobalKey<FormState>();
  final formKeyEnterEmail = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

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
  SignInResponse? signInResponse;
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
    }, (right) async {
      signInResponse=right;
      await CacheHelper.put(key: 'id', value: right.id);
     await CacheHelper.put(key: 'name', value: right.userName);
      emit(LoginSuccessState());
    },
    );
  }

  void sendEmail() {
    emit(SendEmailLoadingState());
    print("dataa ${registerBody?.servantClasses}");
    final response = authRepo.sendEmail(email: emailController.text);
    response.fold((left){
      emit(SendEmailErrorState(left.apiErrorModel.message.toString()));
    }, (right) {
      emit(SendEmailSuccessState());
    },
    );
  }

  void checkOtp() {
    emit(CheckOtpLoadingState());
    print("dataa ${registerBody?.servantClasses}");
    final response = authRepo.checkOtp(email: emailController.text, otp: otpController.text);
    response.fold((left){
      emit(CheckOtpErrorState(left.apiErrorModel.message.toString()));
    }, (right) {
      emit(CheckOtpSuccessState());
    },
    );
  }

  void changePassword() {
    emit(ChangePasswordLoadingState());
    print("dataa ${registerBody?.servantClasses}");
    final response = authRepo.changePassword(email: emailController.text, password: passwordController.text,confirmPassword: confirmPasswordController.text);
    response.fold((left){
      emit(ChangePasswordErrorState(left.apiErrorModel.message.toString()));
    }, (right) {
      emit(ChangePasswordSuccessState());
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

