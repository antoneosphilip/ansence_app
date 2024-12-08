

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/model/get_all_absence_model/get_all_absence_model.dart';
import 'package:summer_school_app/utility/database/local/absence.dart';

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


  Future<void> getAllAbsence() async {
    emit(GetAllAbsenceLoadingState());
    final response = await absenceRepo.getAllAbsence();
    response.fold(
          (l) {
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
              final student = item.student;
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
              );

              if (!studentList.any((s) => s.id == studentModel.id||studentList.isEmpty)) {
                studentList.add(studentModel);
              }

            }

            await box.put('students', studentList);

            print("Data stored successfully!");



            emit(GetAllAbsenceSuccessState());
      },
    );
  }


  List<StudentData> offlineStudentAbsence=[];
  Future<void> addOfflineListToAbsence({required int value}) async {
    offlineStudentAbsence=[];
    final box = await Hive.openBox<List<dynamic>>('studentsBox');

    List<dynamic>? storedStudents = box.get('students', defaultValue: []);

    for (var student in storedStudents!) {
      if(student.studentClass==value){
        print("name${student.name} and attend ${student.absences!.last.attendant!}");
        offlineStudentAbsence.add(student);
      }
    }
    emit(OfflineAbsenceStudentsState());
  }
  void checkConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        isConnected=true;
      } else {
        isConnected=false;
      }
    });
  }
  List<dynamic> studentDataList=[];
  Future<void> addAbsenceStudentList({required StudentData studentData}) async {
    // Open the box
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');

    // Retrieve the current list or initialize an empty list if null
    List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];

    // Add the new student data
    studentDataList.add(studentData);

    // Save the updated list back to the box
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
          print("Updated Attendant: ${storedAllStudents[i].absences.last
              .attendant}");
        }

        await box2.put('students', storedAllStudents);

        break;
      }
    }
    List<dynamic>? storedAllStudents2 = box2.get('students', defaultValue: []);

    storedAllStudents2?.forEach((element) {
      print("nameee${element.name} att${element.absences.last.attendant}");
    },);
    print("storee data");
  }
  Future<void> deleteStudentFromList({required int studentId}) async {
    // Open the box
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');

    // Retrieve the existing list or initialize an empty list
    List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];

    // Remove the student with the matching ID
    studentDataList.removeWhere((student) => student.id == studentId);

    // Save the updated list back to the box
    await box.put('studentsAbsence', studentDataList);

    // Debug: Check stored data after deletion
    List<dynamic>? storedStudents = box.get('studentsAbsence');
    if (storedStudents != null) {
      for (var student in storedStudents) {
        print("Remaining Student Name: ${student.name}");
      }
    } else {
      print("No students found.");
    }
  }
  List<dynamic> getDataAbsenceOfflineList=[];
  Future<void> getDataAbsenceOffline()
  async {
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');

    // Retrieve the existing list or initialize an empty list
    getDataAbsenceOfflineList = box.get('studentsAbsence') ?? [];

  }




}
