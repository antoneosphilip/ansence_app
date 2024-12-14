
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/model/update_absence_student/update_absence_student_body.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';
import 'package:summer_school_app/utility/database/network/end_points.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../core/networking/api_error_handler.dart';

class StudentAbsenceItem extends StatefulWidget {
  final StudentAbsenceModel studentAbsenceModel;

  const StudentAbsenceItem({super.key, required this.studentAbsenceModel});

  @override
  _StudentAbsenceItemState createState() => _StudentAbsenceItemState();
}

class _StudentAbsenceItemState extends State<StudentAbsenceItem> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsenceCubit, AbsenceStates>(
      listener: (BuildContext context, state) {
        if (state is UpdateStudentAbsenceErrorState) {
          print("errorUpdate");
          if (widget.studentAbsenceModel.student.id == state.studentId) {
            widget.studentAbsenceModel.attendant =
            !widget.studentAbsenceModel.attendant;
            showFlutterToast(
                message: "حدث خطأ برجاء المحاولة لاحقا",
                state: ToastState.ERROR);
            setState(() {});
          }
        }
      },
      child: InkWell(
        onTap: () async {
          // final box = await Hive.openBox<List<dynamic>>('studentsBox');
          // await box.clear();
          // sendNotification();
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
              text: widget.studentAbsenceModel.student.studentName!
                  .split(' ')
                  .take(3)
                  .join(' '),
              textStyle: TextStyleManager.textStyle20w700
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Checkbox(
              activeColor: ColorManager.colorPrimary,
              value: widget.studentAbsenceModel.attendant,
              onChanged: (bool? value) {
                AbsenceCubit.get(context).updateStudentAbsence(
                    updateAbsenceStudentBody: UpdateAbsenceStudentBody(
                      id: widget.studentAbsenceModel.student.absences?.last.id,
                      studentId: widget
                          .studentAbsenceModel.student.absences?.last.studentId,
                      attendant: !widget.studentAbsenceModel.attendant,
                      absenceDate: widget
                          .studentAbsenceModel.student.absences?.last
                          .absenceDate,
                      absenceReason: '',
                    ));
                setState(() {
                  widget.studentAbsenceModel.attendant = value ?? false;
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

