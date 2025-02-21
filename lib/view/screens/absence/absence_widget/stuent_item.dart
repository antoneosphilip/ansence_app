
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
                print( widget.studentAbsenceModel.student.profileImage,);
                showImageDialog(context, widget.studentAbsenceModel.student.profileImage,);
              },
              child: SizedBox(
                width: 50.w,
                height: 50.h,
               child: CustomCachedImage(imageUrl: widget.studentAbsenceModel.student.profileImage,),
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

