import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/model/get_all_absence_model/get_all_absence_model.dart';
import 'package:summer_school_app/utility/database/local/absence.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:workmanager/workmanager.dart';

import '../../../model/get_absence_model/get_members_model.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../../utility/database/local/student.dart';
import '../../repo/absence_repo/absence.dart';
import 'absence_states.dart';

class AbsenceCubit extends Cubit<AbsenceStates> {
  AbsenceRepo absenceRepo;

  AbsenceCubit(this.absenceRepo) : super(AbsenceInitialState());

  static AbsenceCubit get(context) => BlocProvider.of<AbsenceCubit>(context);
  List<StudentAbsenceModel> studentAbsenceModel = [];
  List<GetAllAbsenceModel> getAllStudentAbsenceModel = [];
  StreamSubscription? _subscription;
  bool isConnected = true;
  int attendanceCount = 0;

  Future<void> getAbsence({required int id}) async {
    emit(GetAbsenceLoadingState());
    final response = await absenceRepo.getAbsence(id: id);
    response.fold(
      (l) {
        emit(GetAbsenceErrorState(l.apiErrorModel.message.toString()));
      },
      (r) {
        // for (int i = 0; i < r.length; i++) {
        //   print(r[i].student.absences);
        // }
        studentAbsenceModel.clear();
        studentAbsenceModel.addAll(r);
        attendanceCount=0;
        for(int i=0;i<r.length;i++){
          if(r[i].student.absences!.last.attendant!){
            attendanceCount=attendanceCount+1;
          }
        }

        emit(GetAbsenceSuccessState());
      },
    );
  }

  Future<void> updateStudentAbsence(
      {required UpdateAbsenceStudentBody updateAbsenceStudentBody}) async {
    emit(UpdateStudentAbsenceLoadingState());
    final response = await absenceRepo.updateStudentAbsence(
        updateAbsenceStudentBody: updateAbsenceStudentBody);

    response.fold(
      (l) {
        print("errorrrrr");
        emit(UpdateStudentAbsenceErrorState(l.apiErrorModel.message.toString(),
            updateAbsenceStudentBody.studentId!));
      },
      (r) {
        emit(UpdateStudentAbsenceSuccessState());
      },
    );
  }

  Future<void> updateStudentAbsenceOffline() async {
    print("hellllo");
    emit(UpdateStudentAbsenceLoadingState());
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');
    List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];
    print("dddddddddddddddddddd");
    if (studentDataList.isNotEmpty) {
      for (var studItem in studentDataList) {
        final response = await absenceRepo.updateStudentAbsence(
          updateAbsenceStudentBody: UpdateAbsenceStudentBody(
            id: studItem.absences.last.id,
            attendant: studItem.absences.last.attendant,
            absenceDate: studItem.absences.last.absenceDate!,
            absenceReason: studItem.absences.last.absenceReason!,
            studentId: studItem.absences.last.studentId,
          ),
        );
        response.fold(
          (l) {
            print("errorrrrr");
            emit(UpdateStudentAbsenceErrorState(
              l.apiErrorModel.message.toString(),
              studItem.absences.last.id,
            ));
          },
          (r) {
            studentDataList.remove(studItem);
            box.put(
                'studentsAbsence', studentDataList); // تحديث القائمة في Hive
            print("yessssssss sucesssssssssss");
            emit(UpdateStudentAbsenceSuccessState());
          },
        );
      }
    }
  }

  Future<void> getAllAbsence() async {
    emit(GetAllAbsenceLoadingState());
    final response = await absenceRepo.getAllAbsence();
    response.fold(
      (l) {
        print("errrorrrrrrrrr${l.apiErrorModel.message}");
          showFlutterToast(message: "حدث خطأ في تحميل الداتا حاول لاحقا", state: ToastState.ERROR);
        emit(GetAllAbsenceErrorState(l.apiErrorModel.message.toString()));
      },
      (r) async {
        // for (int i = 0; i < r.length; i++) {
        //   print(r[i].student.absences);
        // }
        //     print("sucessssssssssssssssss");
        //     getAllStudentAbsenceModel.clear();
        //     getAllStudentAbsenceModel.addAll(r);
        final box = await Hive.openBox<List<dynamic>>('studentsBox');
        await box.clear();
        List<dynamic> studentList = [];

        for (var item in r) {
          final student = item;
          print("studId ${student.absences!.last.id}");
          // final lastAbsenceStudent=item.student.absences!.last;
          final lastAbsence = student.absences?.isNotEmpty == true
              ? Absence(
                  id: student.absences!.last.id!,
                  studentId: student.absences!.last.studentId!,
                  absenceDate: student.absences!.last.absenceDate!,
                  absenceReason: student.absences!.last.absenceReason!,
                  attendant: student.absences!.last.attendant!,
                )
              : null;

          final studentModel = StudentData(
            id: student.id!,
            name: student.studentName!,
            studentClass: student.studentClass!,
            level: student.level!,
            birthDate: student.birthDate,
            absences: lastAbsence != null ? [lastAbsence] : [],
            gender: student.gender!,
            notes: student.notes ?? "",
            numberOfAbsences: student.numberOfAbsences!,
            shift: student.shift!,
            age: student.age,
            dadPhone: student.dadPhone,
            mamPhone: student.mamPhone,
            studPhone: student.studPhone,
            profileImage: student.profileImage,
          );

          if (!studentList
              .any((s) => s.id == studentModel.id || studentList.isEmpty)) {
            studentList.add(studentModel);
          }
        }

        await box.put('students', studentList);

        print("Data stored successfully!");
          showFlutterToast(message: "تم تحميل الداتا بنجاح", state: ToastState.SUCCESS);
        emit(GetAllAbsenceSuccessState());
      },
    );
  }

  List<StudentData> offlineStudentAbsence = [];

  int absenceLengthOffline=0;
  Future<void> addOfflineListToAbsence({required int value}) async {
    offlineStudentAbsence = [];
    final box = await Hive.openBox<List<dynamic>>('studentsBox');

    List<dynamic>? storedStudents = box.get('students', defaultValue: []);

    for (var student in storedStudents!) {
      if (student.studentClass == value) {
        print(
            "name${student.name} and attend ${student.absences!.last.attendant!}");
        offlineStudentAbsence.add(student);
      }
    }
    absenceLengthOffline=0;
    for(int i=0;i<offlineStudentAbsence.length;i++){
      if(offlineStudentAbsence[i].absences!.last.attendant){
        absenceLengthOffline=absenceLengthOffline+1;
      }
    }
    emit(OfflineAbsenceStudentsState());
  }

  NumbersModel? numbersModel;
  NumbersModel? numbersOfflineModel;

  // الدالة الجديدة لجلب وتخزين الـ classes
  Future<void> getClassNumbers({required String id}) async {
    emit(GetClassesNumberLoadingState());

    final response = await absenceRepo.getClassesNumber(id: id);

    response.fold(
          (l) {
        print("Error loading classes: ${l.apiErrorModel.message}");
        emit(GetClassesNumberErrorState(l.apiErrorModel.message.toString()));
      },
          (r) async {
        try {
          // حفظ الـ model
          numbersModel = r;

          // فتح box للـ classes
          final box = await Hive.openBox<List<dynamic>>('classesBox');

          // مسح البيانات القديمة
          await box.clear();

          // تخزين الأرقام مباشرة (مش محتاجين toJson لأنها int)
          await box.put('classes', r.numbers);
          print("Classes stored successfully! Total: ${r.numbers.length}");
          await getClassesFromLocal();
          emit(GetClassesNumberSuccessState());
        } catch (e) {
          print("Error storing classes: $e");

          emit(GetClassesNumberErrorState("فشل تخزين البيانات"));
        }
      },
    );
  }
  // دالة لقراءة الـ classes من الـ offline storage
  Future<void> getClassesFromLocal() async {
    try {
      final box = await Hive.openBox<List<dynamic>>('classesBox');
      final data = box.get('classes');

      numbersOfflineModel=NumbersModel.fromJson(data!);
    } catch (e) {
      print("Error reading local classes: $e");
    }
  }

  void checkConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        isConnected = true;
        // Workmanager().registerOneOffTask("task-identifier", "simpleTask",
        //   constraints: Constraints(networkType: NetworkType.connected),
        // );
        showFlutterToast(message: "انت الان في وضع الاونلاين", state: ToastState.SUCCESS,time: 2);

      } else {
        showFlutterToast(message: "انت الان في وضع الاوفلاين", state: ToastState.ERROR,time: 2);
        isConnected = false;
      }
    });
  }

  List<dynamic> studentDataList = [];

  Future<void> addAbsenceStudentList({required StudentData studentData}) async {
    // Open the box
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');

    // Retrieve the current list or initialize an empty list if null
    List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];

    if(!studentDataList.contains(studentData)){
      studentDataList.add(studentData);
    }

    await box.put('studentsAbsence', studentDataList);

    // Debug: Check stored data
    final box2 = await Hive.openBox<List<dynamic>>('studentsBox');
    List<dynamic>? storedAllStudents = box2.get('students', defaultValue: []);

    for (var student in studentDataList) {
      print("nameee${student.name}");
    }
    for (int i = 0; i < storedAllStudents!.length; i++) {
      if (storedAllStudents[i].id == studentData.id) {
        // تعديل القيمة داخل الكائن
        if (storedAllStudents[i].absences.isNotEmpty) {
          storedAllStudents[i].absences.last.attendant = false;
          print("تم التعديل بنجاح");
          print("Student Name: ${storedAllStudents[i].name}");
          print("id : ${storedAllStudents[i].absences!.last.id}");
          print("studId : ${storedAllStudents[i].absences!.last.studentId!}");


          print(
              "Updated Attendant: ${storedAllStudents[i].absences.last.attendant}");
          absenceLengthOffline=absenceLengthOffline-1;
          emit(ChangeAbsenceLength());
        }

        await box2.put('students', storedAllStudents);

        break;
      }
    }
    List<dynamic> studentDataList2 = box.get('studentsAbsence') ?? [];
    studentDataList2.forEach(
      (element) {
        print("Name :${element.name}");
      },
    );
  }

  Future<void> deleteStudentFromList({required StudentData studentData}) async {
    // Open the box
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');

    // Retrieve the existing list or initialize an empty list
    List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];

    // Remove the student with the matching ID
    if(studentDataList.isNotEmpty) {
      print("llll${studentDataList.length}");
      if(!studentDataList.contains(studentData)){
        studentData.absences!.last.attendant == true;
        studentDataList.add(studentData);
      }
      else {
        for (var studentDataListItem in studentDataList) {
          print("llll${studentDataListItem.name}");
          if (studentDataListItem.id == studentData.id) {
            studentDataListItem.absences.last.attendant == true;
          }
        }
      }
      absenceLengthOffline=absenceLengthOffline+1;
      emit(ChangeAbsenceLength());

    }
    else{
      studentData.absences!.last.attendant == true;
      studentDataList.add(studentData);
    }
    for (var element in studentDataList) {
      print("name in list ${element.name}");
      print("att in list ${element.absences!.last.attendant}");

    }await box.put('studentsAbsence', studentDataList);

    // Debug: Check stored data after deletion
    List<dynamic>? storedStudents = box.get('studentsAbsence');
    if (storedStudents != null) {
      for (var student in storedStudents) {
        print("Remaining Student Name: ${student.name}");
      }
    } else {
      print("No students found.");
    }
    final box2 = await Hive.openBox<List<dynamic>>('studentsBox');
    List<dynamic>? storedAllStudents = box2.get('students', defaultValue: []);

    for (var student in studentDataList) {
      print("nameee${student.name}");
    }
    for (int i = 0; i < storedAllStudents!.length; i++) {
      if (storedAllStudents[i].id == studentData.id) {
        // تعديل القيمة داخل الكائن
        if (storedAllStudents[i].absences.isNotEmpty) {
          storedAllStudents[i].absences.last.attendant = true;
          print("تم التعديل بنجاح");
          print("Student Name: ${storedAllStudents[i].name}");
          print(
              "Updated Attendant: ${storedAllStudents[i].absences.last.attendant}");
        }

        await box2.put('students', storedAllStudents);

        break;
      }
    }
  }

  List<dynamic> getDataAbsenceOfflineList = [];

  Future<void> getDataAbsenceOffline() async {
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');

    // Retrieve the existing list or initialize an empty list
    getDataAbsenceOfflineList = box.get('studentsAbsence') ?? [];
  }



  void changeAbsence({required bool isValue}) {
    print("valuueee $isValue");
    attendanceCount = isValue
        ? attendanceCount + 1
        : attendanceCount - 1;
    print("legnthhh ${studentAbsenceModel.length}");
    emit(ChangeAbsenceLength());
  }

}
