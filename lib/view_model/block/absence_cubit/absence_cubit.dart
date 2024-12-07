

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
              final lastAbsenceStudent=item.student.absences!.last;


              // إنشاء نموذج الطالب
              final studentModel = StudentData(
                id: student.id!,
                name: student.studentName!,
                studentClass: student.studentClass!,
                level: student.level!,
                birthDate: student.birthDate,
                absences: Absence(id: lastAbsenceStudent.id!, studentId: lastAbsenceStudent.studentId!,
                    absenceDate: lastAbsenceStudent.absenceDate!, absenceReason: lastAbsenceStudent.absenceReason!,
                    attendant: lastAbsenceStudent.attendant!),
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


}
