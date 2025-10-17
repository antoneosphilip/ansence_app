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
import '../../../core_widget/custom_Cached_network/cusotm_chaced_netwok.dart';
import '../../../core_widget/show_dialog_image/show_dialog_image.dart';

class StudentAbsenceItem extends StatefulWidget {
  final Student studentAbsenceModel;

  const StudentAbsenceItem({super.key, required this.studentAbsenceModel});

  @override
  _StudentAbsenceItemState createState() => _StudentAbsenceItemState();
}

class _StudentAbsenceItemState extends State<StudentAbsenceItem> {
  late Student _studentModel;

  @override
  void initState() {
    super.initState();
    _studentModel = widget.studentAbsenceModel;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AbsenceCubit, AbsenceStates>(
      listener: (BuildContext context, state) {
        if (state is UpdateStudentAbsenceErrorState) {
          if (_studentModel.id == state.studentId) {
            setState(() {
              _studentModel = _studentModel.copyWith(
                lastAttendance: !_studentModel.lastAttendance!,
              );
            });

            showFlutterToast(
              message: "حدث خطأ برجاء المحاولة لاحقًا",
              state: ToastState.ERROR,
            );
          }
        }
      },
      child: InkWell(
        onTap: () {
          final now = DateTime.now();
          print("weekday: ${now.weekday}");
          print("day: ${now.day}");
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: () {
                print(_studentModel.profileImage);
                showImageDialog(context, _studentModel.profileImage);
              },
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: CustomCachedImage(imageUrl: _studentModel.profileImage),
              ),
            ),
            SizedBox(width: 10.w),
            TextWidget(
              text: _studentModel.studentName!
                  .split(' ')
                  .take(3)
                  .join(' '),
              textStyle: TextStyleManager.textStyle20w700.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Checkbox(
              activeColor: ColorManager.colorPrimary,
              value: _studentModel.lastAttendance ?? false,
              onChanged: (bool? value) {
                final lastAbsence = _studentModel.absences?.last;

                if (lastAbsence != null) {
                  AbsenceCubit.get(context).updateStudentAbsence(
                    updateAbsenceStudentBody: UpdateAbsenceStudentBody(
                      id: lastAbsence.id,
                      studentId: lastAbsence.studentId,
                      absenceDate: lastAbsence.absenceDate,
                      absenceReason: lastAbsence.absenceReason ?? '',
                      attendant: !( _studentModel.lastAttendance ?? false),
                      alhanAttendant: !lastAbsence.alhanAttendant,
                      copticAttendant: !lastAbsence.copticAttendant,
                      tacsAttendant: !lastAbsence.tacsAttendant,
                      student: lastAbsence.student != null
                          ? Student(
                        id: lastAbsence.student!.id,
                        studentName: lastAbsence.student!.name,
                        classId: lastAbsence.student!.classId,
                        lastAttendance: !( _studentModel.lastAttendance ?? false),
                      )
                          : null,
                    ),
                  );
                }

                AbsenceCubit.get(context).updateStatistics(
                  classNumber: _studentModel.studentClass ?? 0,
                  isAttendant: value ?? false,
                );

                setState(() {
                  _studentModel = _studentModel.copyWith(
                    lastAttendance: value ?? false,
                  );
                });

                AbsenceCubit.get(context).changeAbsence(
                  isValue: value ?? false,
                );
              },
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
