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

import '../../../model/get_absence_model/get_capacity.dart';
import '../../../model/get_absence_model/get_members_model.dart';
import '../../../model/get_missing_student_model/get_missing_classes.dart';
import '../../../model/update_absence_student/update_absence_student_body.dart';
import '../../../utility/database/local/cache_helper.dart';
import '../../../utility/database/local/student.dart';
import '../../repo/absence_repo/absence.dart';
import 'absence_states.dart';

class AbsenceCubit extends Cubit<AbsenceStates> {
  AbsenceRepo absenceRepo;

  AbsenceCubit(this.absenceRepo) : super(AbsenceInitialState());

  static AbsenceCubit get(context) => BlocProvider.of<AbsenceCubit>(context);
  List<Student> studentAbsenceModel = [];
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
          if(r[i].absences!.last.attendant!){
            attendanceCount=attendanceCount+1;
          }
        }

        emit(GetAbsenceSuccessState());
      },
    );
  }
  ClassStatisticsResponse? classStatisticsResponse;
  List<ClassStatistics> ?classStatistic;
  int totalCapacity = 0;
  int totalAttendants = 0;
  int totalAbsents = 0;
  ClassStatistics? firstClass;
  ClassStatisticsResponse? classStatisticsOfflineResponse;




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
          print("studId ${student.id}");
          print("studName ${student.studentName}");

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
            studentClass: student.studentClass??0,
            level: student.level??0,
            birthDate: student.birthDate,
            absences: lastAbsence != null ? [lastAbsence] : [],
            gender: student.gender!,
            notes: student.notes ?? "",
            numberOfAbsences: student.numberOfAbsences!,
            shift: student.shift??0,
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
        // await getClassNumbers(id: CacheHelper.getDataString(key: 'id'));

        print("Data stored successfully!");
        emit(GetAllAbsenceSuccessState());
        showFlutterToast(message: "تم تحميل الداتا بنجاح", state: ToastState.SUCCESS);

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
      print("chosssee ${student.studentClass} ");
      print("chosssee2222 ${value} ");

      if (student.studentClass == value) {
        print("equallll");
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
// Fixed getCapacities method
  Future<void> getCapacities({required String servantId}) async {
    emit(GetCapacityLoadingState());
    final response = await absenceRepo.getCapacities(id: servantId);
    response.fold(
          (l) {
        print("errorrrrrrrrrrrrrr ${l.apiErrorModel.message}");
        emit(GetCapacityErrorState(l.apiErrorModel.message.toString()));
      },
          (r) async {
        classStatisticsResponse = r;
        if (r.classes.isNotEmpty) {
          firstClass = r.classes.first;
        }

        final box = await Hive.openBox<List<dynamic>>('capacityBox');
        await box.clear();

        // ✅ Convert ClassStatistics objects to JSON maps
        List<Map<String, dynamic>> classesJson =
        r.classes.map((cls) => cls.toJson()).toList();

        await box.put('capacity', classesJson);
        print("rrrrrrrrr ${classesJson}");
        print("sssssssttttt ${classesJson}");

        await getCapacityFromLocal();
        emit(GetCapacitySuccessState());
      },
    );
  }

// Fixed getCapacityFromLocal method
  Future<void> getCapacityFromLocal() async {
    try {
      final box = await Hive.openBox<List<dynamic>>('capacityBox');
      final data = box.get('capacity');
      print("dataaaaaaaa ${data}");

      if (data != null && data is List) {
        // ✅ Cast Map<dynamic, dynamic> to Map<String, dynamic>
        List<Map<String, dynamic>> classesJson = data.map((item) {
          return Map<String, dynamic>.from(item as Map);
        }).toList();

        classStatisticsOfflineResponse = ClassStatisticsResponse.fromJson(classesJson);
        print("Loaded ${classStatisticsOfflineResponse?.classes.length} classes from local storage");
      } else {
        print("No capacity data found in local storage");
      }
    } catch (e) {
      print("Error reading local classes: $e");
    }
  }
  // الدالة الجديدة لجلب وتخزين الـ classes

  // ✅ دالة لتحديث الإحصائيات الأونلاين
  Future<void> updateOnlineStatistics({
    required int classNumber,
    required bool isAttendant,
  }) async {
    if (classStatisticsResponse != null) {
      final classIndex = classStatisticsResponse!.classes
          .indexWhere((cls) => cls.classNumber == classNumber);

      if (classIndex != -1) {
        final currentClass = classStatisticsResponse!.classes[classIndex];

        final updatedClass = ClassStatistics(
          classNumber: currentClass.classNumber,
          capacity: currentClass.capacity,
          numberOfAttendants: isAttendant
              ? currentClass.numberOfAttendants + 1
              : currentClass.numberOfAttendants - 1,
          numberOfAbsents: isAttendant
              ? currentClass.numberOfAbsents - 1
              : currentClass.numberOfAbsents + 1,
        );
        print("updateee dataaa");
        // استبدال الفصل المحدث
        classStatisticsResponse!.classes[classIndex] = updatedClass;

        // تحديث firstClass إذا كان نفس الفصل
        if (firstClass?.classNumber == classNumber) {
          firstClass = updatedClass;
        }

        emit(UpdateStatisticsState());
        print("✅ تم تحديث إحصائيات الفصل $classNumber - أونلاين");
      }
    }
  }

// ✅ دالة لتحديث الإحصائيات الأوفلاين
  Future<void> updateOfflineStatistics({
    required int classNumber,
    required bool isAttendant,
  }) async {
    print("updateee dataaa${classNumber}");

    if (classStatisticsOfflineResponse != null) {

      // البحث عن الفصل المحدد
      final classIndex = classStatisticsOfflineResponse!.classes
          .indexWhere((cls) => cls.classNumber == classNumber);

      if (classIndex != -1) {

        final currentClass = classStatisticsOfflineResponse!.classes[classIndex];

        // تحديث الأعداد
        final updatedClass = ClassStatistics(
          classNumber: currentClass.classNumber,
          capacity: currentClass.capacity,
          numberOfAttendants: isAttendant
              ? currentClass.numberOfAttendants + 1
              : currentClass.numberOfAttendants - 1,
          numberOfAbsents: isAttendant
              ? currentClass.numberOfAbsents - 1
              : currentClass.numberOfAbsents + 1,
        );
        // استبدال الفصل المحدث
        classStatisticsOfflineResponse!.classes[classIndex] = updatedClass;

        // حفظ التحديث في Hive
        await saveOfflineStatisticsToHive();

        emit(UpdateStatisticsState());
        print("✅ تم تحديث إحصائيات الفصل $classNumber - أوفلاين");
      }
    }
  }

// ✅ دالة مساعدة لحفظ الإحصائيات في Hive
  Future<void> saveOfflineStatisticsToHive() async {
    try {
      final box = await Hive.openBox<List<dynamic>>('capacityBox');

      if (classStatisticsOfflineResponse != null) {
        List<Map<String, dynamic>> classesJson =
        classStatisticsOfflineResponse!.classes
            .map((cls) => cls.toJson())
            .toList();

        await box.put('capacity', classesJson);
        print("💾 تم حفظ الإحصائيات المحدثة في Hive");
      }
    } catch (e) {
      print("❌ خطأ في حفظ الإحصائيات: $e");
    }
  }

// ✅ دالة موحدة لتحديث الإحصائيات (أونلاين وأوفلاين)
  Future<void> updateStatistics({
    required int classNumber,
    required bool isAttendant,
  }) async {
    await updateOnlineStatistics(
      classNumber: classNumber,
      isAttendant: isAttendant,
    );
    await updateOfflineStatistics(
      classNumber: classNumber,
      isAttendant: isAttendant,
    );

  }
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
  MissingClasses? numbersMissingClassesModel;
  Future<void> checkMissingClasses(
      {required String servantId}) async {
    emit(GetMissingClassesLoadingState());
    final response = await absenceRepo.checkMissingStudents(
        servantId: servantId);

    response.fold(
          (l) {
        print("errorrrrr");
        emit(GetMissingClassesErrorState(l.apiErrorModel.message.toString()));
      },
          (r) {
            numbersMissingClassesModel=r;
        emit(GetMissingClassesSuccessState());
      },
    );
  }
  // دالة لقراءة الـ classes من الـ offline storage
  Future<void> getClassesFromLocal() async {
    try {
      final box = await Hive.openBox<List<dynamic>>('classesBox');
      final data = box.get('classes');
      print("dataaaaa ${data}");
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
