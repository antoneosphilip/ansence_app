import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/auth_response/class_data.dart';
import 'login_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  List<ClassData> classes = [];

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

  void signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    String? classValidationMessage = getClassValidationMessage();

    if (classValidationMessage != null) {
      emit(AuthErrorState(classValidationMessage));
      return;
    }

    emit(AuthLoadingState());

    try {
      Future.delayed(Duration(seconds: 2), () {
        emit(AuthSuccessState());
      });
    } catch (error) {
      emit(AuthErrorState('حدث خطأ غير متوقع'));
    }
  }
  void login({
    required String phone,
    required String password,
  }) {
    emit(LoginLoadingState());

    try {
      // محاكاة عملية تسجيل الدخول
      Future.delayed(Duration(seconds: 2), () {
        // يمكن إضافة validation هنا
        if (phone.isEmpty || password.isEmpty) {
          emit(LoginErrorState('يرجى ملء جميع الحقول'));
          return;
        }

        if (password.length < 6) {
          emit(LoginErrorState('كلمة المرور يجب أن تكون 6 أحرف على الأقل'));
          return;
        }

        // في حالة النجاح
        emit(LoginSuccessState());
      });
    } catch (error) {
      emit(LoginErrorState('حدث خطأ غير متوقع'));
    }
  }
}

