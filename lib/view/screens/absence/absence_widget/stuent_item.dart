
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
import '../../../core_widget/custom_Cached_network/cusotm_chaced_netwok.dart';
import '../../../core_widget/show_dialog_image/show_dialog_image.dart';

class StudentAbsenceItem extends StatefulWidget {
  final Student studentAbsenceModel;

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
          if (widget.studentAbsenceModel.id == state.studentId) {
            final updatedAbsence = widget.studentAbsenceModel.absences!.last.copyWith(
              attendant: !widget.studentAbsenceModel.absences!.last.attendant,
            );

            widget.studentAbsenceModel.absences![widget.studentAbsenceModel.absences!.length - 1] = updatedAbsence;

            showFlutterToast(
                message: "حدث خطأ برجاء المحاولة لاحقا",
                state: ToastState.ERROR);
            setState(() {});
          }
        }
      },
      child: InkWell(
        onTap: () {
          final now = DateTime.now();
          print("hourr ${ DateTime.wednesday}");
          print("hourr ${now.day}");

        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: (){
                print( widget.studentAbsenceModel.profileImage,);
                showImageDialog(context, widget.studentAbsenceModel.profileImage,);
              },
              child: SizedBox(
                width: 50.w,
                height: 50.h,
               child: CustomCachedImage(imageUrl: widget.studentAbsenceModel.profileImage,),
              ),
            ),
            SizedBox(width: 10.w),
            TextWidget(
              text: widget.studentAbsenceModel.studentName!
                  .split(' ')
                  .take(3)
                  .join(' '),
              textStyle: TextStyleManager.textStyle20w700
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Checkbox(
              activeColor: ColorManager.colorPrimary,
              value: widget.studentAbsenceModel.absences!.last.attendant,
              onChanged: (bool? value) {

                final lastAbsence = widget.studentAbsenceModel.absences?.last;

                if (lastAbsence != null) {
                  AbsenceCubit.get(context).updateStudentAbsence(
                    updateAbsenceStudentBody: UpdateAbsenceStudentBody(
                      id: lastAbsence.id,
                      studentId: lastAbsence.studentId,
                      absenceDate: lastAbsence.absenceDate,
                      absenceReason: lastAbsence.absenceReason ?? '',
                      attendant: !lastAbsence.attendant,
                      alhanAttendant: !lastAbsence.alhanAttendant,
                      copticAttendant: !lastAbsence.copticAttendant,
                      tacsAttendant:!lastAbsence.tacsAttendant,
                      student: lastAbsence.student != null
                          ? Student(
                        id: lastAbsence.student!.id,
                        studentName: lastAbsence.student!.name,
                        classId: lastAbsence.student!.classId,

                      )
                          : null,
                    ),
                  );
                }

                AbsenceCubit.get(context).updateStatistics(
                  classNumber: widget.studentAbsenceModel.studentClass ?? 0,
                  isAttendant: value ?? false,
                );
                setState(() {
                  final updatedAbsence = widget.studentAbsenceModel.absences!.last.copyWith(
                    attendant: value ?? false,
                  );
                  widget.studentAbsenceModel.absences![widget.studentAbsenceModel.absences!.length - 1] = updatedAbsence;
                });

                AbsenceCubit.get(context).changeAbsence(isValue: value??false);
              },
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}

