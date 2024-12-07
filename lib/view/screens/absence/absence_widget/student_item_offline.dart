import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/model/update_absence_student/update_absence_student_body.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../utility/database/local/student.dart';

class StudentAbsenceItemOffline extends StatefulWidget {
  final StudentData studentDataOfflineModel;

  const StudentAbsenceItemOffline({super.key, required this.studentDataOfflineModel});

  @override
  _StudentAbsenceItemState createState() => _StudentAbsenceItemState();
}

class _StudentAbsenceItemState extends State<StudentAbsenceItemOffline> {


  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsenceCubit,AbsenceStates>(
      listener: (BuildContext context, state) {
        if(state is UpdateStudentAbsenceErrorState){
          print("errorUpdate");
          // if(widget.studentDataOfflineModel.student.id==state.studentId) {
          //   widget.studentDataOfflineModel.attendant=!widget.studentDataOfflineModel.attendant;
          //   showFlutterToast(message: "حدث خطأ برجاء المحاولة لاحقا", state: ToastState.ERROR);
          //   setState(() {
          //   });
          // }

        }
      },
      child: InkWell(
        onTap: () async {

          final box = await Hive.openBox<List<dynamic>>('studentsBox');

          List<dynamic>? storedStudents = box.get('students', defaultValue: []);

          for (var student in storedStudents!) {
            print("Nameeee${student.name}");
          }


        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16.w),
            InkWell(
              onTap: () {
                print("get data");
                AbsenceCubit.get(context).getAllAbsence();
              },
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/default_image.jpg'))),
              ),
            ),
            SizedBox(width: 10.w),
            TextWidget(
              text: widget.studentDataOfflineModel.name
                  !.split(' ')
                  .take(3)
                  .join(' '),
              textStyle: TextStyleManager.textStyle20w700
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Checkbox(
              activeColor: ColorManager.colorPrimary,
              value: widget.studentDataOfflineModel.absences.attendant,
              onChanged: (bool? value) {
                print(widget.studentDataOfflineModel.absences.attendant );
                // AbsenceCubit.get(context).updateStudentAbsence(
                //     updateAbsenceStudentBody: UpdateAbsenceStudentBody(
                //       id: widget.studentDataOfflineModel.student.absences?.last.id,
                //       studentId:
                //       widget.studentDataOfflineModel.student.absences?.last.studentId,
                //       attendant: !widget.studentDataOfflineModel.attendant,
                //       absenceDate: widget.studentDataOfflineModel.student.absences?.last.absenceDate ,
                //       absenceReason: '',
                //     ));
                setState(() {
                  widget.studentDataOfflineModel.absences.attendant = value ?? false;
                });
              },
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
