import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/model/get_all_absence_model/get_all_absence_model.dart';
import 'package:summer_school_app/utility/database/local/absence.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/networking/api_error_handler.dart';
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

  Future<void> getAbsence({required int classNumber}) async {
    emit(GetAbsenceLoadingState());
    final response = await absenceRepo.getAbsence( classNumber: classNumber,servantId:CacheHelper.getDataString(key: 'id') );
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
          if(r[i].lastAttendance!){
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
            attendant: studItem.lastAttendancet,
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

    try {
      List<Student> allStudents = [];

      // تحقق إذا كان في أرقام أوفلاين
      if (numbersOfflineModel != null && numbersOfflineModel!.numbers.isNotEmpty) {
        for (var item in numbersOfflineModel!.numbers) {
          print("numbersss $item");
          final response = await absenceRepo.getAbsence(classNumber:item,servantId: CacheHelper.getDataString(key: 'id'));

          response.fold(
                (l) {
              print("errorrrrrrrrr ${l.apiErrorModel.message}");
            },
                (r) {
              allStudents.addAll(r);
            },
          );
        }
      } else {
        final response = await absenceRepo.getAllAbsence();

        response.fold(
              (l) {
            print("errorrrrrrrrr ${l.apiErrorModel.message}");
            showFlutterToast(
              message: "حدث خطأ في تحميل الداتا حاول لاحقا",
              state: ToastState.ERROR,
            );
            emit(GetAllAbsenceErrorState(l.apiErrorModel.message.toString()));
            return;
          },
              (r) {
            allStudents.addAll(r);
          },
        );
      }

      // لو مفيش داتا راجعة
      if (allStudents.isEmpty) {
        emit(GetAllAbsenceErrorState("No data found"));
        return;
      }

      // فتح الـ Hive box (يفضل تفتحه في init مرة واحدة)
      final box = await Hive.openBox<List<dynamic>>('studentsBox');
      await box.clear();

      List<dynamic> studentList = [];

      for (var student in allStudents) {
        print("studId ${student.absences?.last.alhanAttendant}");
        print("studName ${student.studentName}");

        final lastAbsence = student.absences?.isNotEmpty == true
            ? Absence(
          id: student.absences?.last.id??'0',
          studentId: student.absences?.last.studentId??"0",
          absenceDate: student.absences?.last.absenceDate??"",
          absenceReason: student.absences?.last.absenceReason??"",
          attendant: student.lastAttendance ?? true,
        )
            : null;

        final studentModel = StudentData(
          id: student.id??"",
          name: student.studentName??"",
          studentClass: student.studentClass??0,
          level: student.level??0,
          birthDate: student.birthDate,
          absences: lastAbsence != null ? [lastAbsence] : [],
          gender: student.gender??0,
          notes: student.notes ?? "",
          numberOfAbsences: student.numberOfAbsences??0,
          shift: student.shift??0,
          age: student.age,
          dadPhone: student.dadPhone,
          mamPhone: student.mamPhone,
          studPhone: student.studPhone,
          profileImage: student.profileImage,
          lastAttendance: student.lastAttendance??true
        );

        if (!studentList.any((s) => s.id == studentModel.id)) {
          studentList.add(studentModel);
        }
      }

      await box.put('students', studentList);

      print("Data stored successfully!");
      getClassNumbers(id: CacheHelper.getDataString(key: 'id'));
      checkMissingClasses(servantId: CacheHelper.getDataString(key: 'id'));
      getCapacities(servantId: CacheHelper.getDataString(key: 'id'));
      getClassesFromLocal();
      getCapacityFromLocal();
      emit(GetAllAbsenceSuccessState());
      showFlutterToast(
        message: "تم تحميل الداتا بنجاح",
        state: ToastState.SUCCESS,
      );

    } catch (e) {
      print("Exception in getAllAbsence: $e");
      showFlutterToast(
        message: "حدث خطأ غير متوقع",
        state: ToastState.ERROR,
      );
      emit(GetAllAbsenceErrorState(e.toString()));
    }
  }

  List<StudentData> offlineStudentAbsence = [];
  Future<void> getAllAbsenceFromStart() async {
    if(isConnected){
      final box = await Hive.openBox<List<dynamic>>('studentsBox');

      List<dynamic>? storedStudents = box.get('students', defaultValue: []);
      if(storedStudents?.isEmpty??true){
       getAllAbsence();
      }
      }

  }
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
            "name${student.name} and attend ${student.lastAttendance}");
        offlineStudentAbsence.add(student);
      }
    }
    absenceLengthOffline=0;
    for(int i=0;i<offlineStudentAbsence.length;i++){
      if(offlineStudentAbsence[i].lastAttendance??true){
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

  // ✅ دالة لتحديث الإحصائيات الأوفلاين مع التحقق من الحدود
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

        // حساب القيم الجديدة
        int newAttendants = isAttendant
            ? currentClass.numberOfAttendants + 1
            : currentClass.numberOfAttendants - 1;

        int newAbsents = isAttendant
            ? currentClass.numberOfAbsents - 1
            : currentClass.numberOfAbsents + 1;



        // 2. عدد الحضور لا يقل عن صفر
        if (newAttendants < 0) {
          print("⚠️ تحذير: عدد الحضور لا يمكن أن يكون سالب");
          newAttendants = 0;
        }

        // 3. عدد الغياب لا يقل عن صفر
        if (newAbsents < 0) {
          print("⚠️ تحذير: عدد الغياب لا يمكن أن يكون سالب");
          newAbsents = 0;
        }

        // 4. التأكد من أن المجموع لا يتجاوز السعة
        if (newAttendants + newAbsents > currentClass.capacity) {
          print("⚠️ خطأ: مجموع الحضور والغياب يتجاوز السعة");
          return;
        }

        // تحديث الأعداد
        final updatedClass = ClassStatistics(
          classNumber: currentClass.classNumber,
          capacity: currentClass.capacity,
          numberOfAttendants: newAttendants,
          numberOfAbsents: newAbsents,
        );

        // استبدال الفصل المحدث
        classStatisticsOfflineResponse!.classes[classIndex] = updatedClass;

        // حفظ التحديث في Hive
        await saveOfflineStatisticsToHive();

        emit(UpdateStatisticsState());
        print("✅ تم تحديث إحصائيات الفصل $classNumber - أوفلاين");
        print("📊 الحضور: $newAttendants / ${currentClass.capacity}, الغياب: $newAbsents");
      }
    }
  }

// ✅ دالة لتحديث الإحصائيات الأونلاين مع التحقق من الحدود
  Future<void> updateOnlineStatistics({
    required int classNumber,
    required bool isAttendant,
  }) async {
    if (classStatisticsResponse != null) {
      final classIndex = classStatisticsResponse!.classes
          .indexWhere((cls) => cls.classNumber == classNumber);

      if (classIndex != -1) {
        final currentClass = classStatisticsResponse!.classes[classIndex];

        // حساب القيم الجديدة
        int newAttendants = isAttendant
            ? currentClass.numberOfAttendants + 1
            : currentClass.numberOfAttendants - 1;

        int newAbsents = isAttendant
            ? currentClass.numberOfAbsents - 1
            : currentClass.numberOfAbsents + 1;

        // 2. عدد الحضور لا يقل عن صفر
        if (newAttendants < 0) {
          print("⚠️ تحذير: عدد الحضور لا يمكن أن يكون سالب");
          newAttendants = 0;
        }

        // 3. عدد الغياب لا يقل عن صفر
        if (newAbsents < 0) {
          print("⚠️ تحذير: عدد الغياب لا يمكن أن يكون سالب");
          newAbsents = 0;
        }

        // 4. التأكد من أن المجموع لا يتجاوز السعة
        if (newAttendants + newAbsents > currentClass.capacity) {
          print("⚠️ خطأ: مجموع الحضور والغياب يتجاوز السعة");
          return;
        }

        final updatedClass = ClassStatistics(
          classNumber: currentClass.classNumber,
          capacity: currentClass.capacity,
          numberOfAttendants: newAttendants,
          numberOfAbsents: newAbsents,
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
        print("📊 الحضور: $newAttendants / ${currentClass.capacity}, الغياب: $newAbsents");
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

// ✅ (اختياري) State جديد للتنبيه عند الوصول للحد الأقصى
// أضفه في ملف states الخاص بك
// class MaxCapacityReachedState extends YourStateName {}
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
        showFlutterToast(message: "وضع الاونلاين", state: ToastState.SUCCESS,time: 2);

      } else {
        showFlutterToast(message: "وضع الاوفلاين", state: ToastState.ERROR,time: 2);
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
        if (storedAllStudents[i]!=null) {
          // storedAllStudents[i].absences.last.alhanAttendant = false;
          // storedAllStudents[i].absences.last.copticAttendant = false;
          // storedAllStudents[i].absences.last.tacsAttendant = false;
          storedAllStudents[i].lastAttendance = false;

          print("تم التعديل بنجاح");
          print("Student Name: ${storedAllStudents[i].name}");
          print("id : ${storedAllStudents[i].absences!.last.id}");
          print("studId : ${storedAllStudents[i].absences!.last.studentId!}");


          print(
              "Updated Attendant: ${storedAllStudents[i].lastAttendance}");
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
        // studentData.absences!.last.alhanAttendant = true;
        // studentData.absences!.last.copticAttendant = true;
        // studentData.absences!.last.tacsAttendant = true;
        studentData.lastAttendance = true;

        studentDataList.add(studentData);
      }
      else {
        for (var studentDataListItem in studentDataList) {
          print("llll${studentDataListItem.name}");
          if (studentDataListItem.id == studentData.id) {
            // studentData.absences!.last.alhanAttendant = true;
            // studentData.absences!.last.copticAttendant = true;
            // studentData.absences!.last.tacsAttendant = true;
            studentData.lastAttendance = true;

          }
        }
      }
      absenceLengthOffline=absenceLengthOffline+1;
      emit(ChangeAbsenceLength());

    }
    else{
      // studentData.absences!.last.alhanAttendant = true;
      // studentData.absences!.last.copticAttendant= true;
      // studentData.absences!.last.tacsAttendant = true;
      studentData.lastAttendance = true;

      studentDataList.add(studentData);
    }
    for (var element in studentDataList) {
      print("name in list ${element.name}");
      print("att in list ${element.lastAttendance}");

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
          // studentData.absences!.last.alhanAttendant = true;
          // studentData.absences!.last.copticAttendant = true;
          // studentData.absences!.last.tacsAttendant = true;
          studentData.lastAttendance = true;

          print("تم التعديل بنجاح");
          print("Student Name: ${storedAllStudents[i].name}");
          print(
              "Updated Attendant: ${storedAllStudents[i].lastAttendance}");
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
