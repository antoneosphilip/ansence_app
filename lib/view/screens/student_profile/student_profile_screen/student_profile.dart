import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/model/update_absence_student/update_absence_student_body.dart';
import 'package:summer_school_app/view/core_widget/absence_appbar/absence_appbar.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view/core_widget/xstation_button_custom/x_station_button_custom.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';

import '../../../../model/get_missing_student_model/get_missing_student_model.dart';
import '../student_profile_widget/call_buttons.dart';
import '../student_profile_widget/reason_text_form_field.dart';

class StudentProfile extends StatelessWidget {
  final GetMissingStudentModel getMissingStudentModel;
  final MissingCubit missingCubit;

  const StudentProfile(
      {super.key,
      required this.getMissingStudentModel,
      required this.missingCubit});

  @override
  Widget build(BuildContext context) {
    absenceReasonHandle(
        getMissingStudentModel: getMissingStudentModel,
        missingCubit: missingCubit);
    return BlocProvider.value(
        value: missingCubit,
        child: BlocConsumer<MissingCubit, MissingStates>(
          listener: (BuildContext context, MissingStates state) async {
            if (state is UpdateStudentMissingLoadingState) {
              EasyLoading.show(indicator: _customLoadingIndicator());
              Future.delayed(const Duration(seconds: 2), () {
                EasyLoading.dismiss();
              });
            } else if (state is UpdateStudentMissingSuccessState) {
              EasyLoading.dismiss();
              showFlutterToast(
                  message: "تم الحفظ بنجاح", state: ToastState.SUCCESS);
            } else if (state is UpdateStudentMissingErrorState) {
              EasyLoading.dismiss();
              showFlutterToast(
                  message: "حدث خطأ في الحفظ حاول لاحقا",
                  state: ToastState.ERROR);
            }
          },
          builder: (BuildContext context, MissingStates state) {
            return PopScope(
              onPopInvoked: (didPop) {
                EasyLoading.dismiss();
              },
              child: Form(
                key: MissingCubit.get(context).formKey,
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 35.h),
                                  child: const AbsenceAppbar(
                                      text: "بيانات الطالب"),
                                ),
                                Container(
                                  width: 75.w,
                                  height: 75.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/default_image.jpg'))),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'الأسم :',
                                        style: TextStyleManager.textStyle22w800,
                                      ),
                                      Text(
                                        ' ${getMissingStudentModel.studentName}',
                                        style: TextStyleManager.textStyle20w500
                                            .copyWith(
                                                color:
                                                    ColorManager.colorPrimary),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'الفصل :',
                                        style: TextStyleManager.textStyle20w500
                                            .copyWith(
                                                fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        ' ${getMissingStudentModel.studentClass}',
                                        style: TextStyleManager.textStyle20w500
                                            .copyWith(
                                                color:
                                                    ColorManager.colorPrimary),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  const ReasonTextFormField(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            CallButtons(
                              getMissingStudentModel: getMissingStudentModel,
                            ),
                            SizedBox(
                              height: 180.h,
                            ),
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: AbsenceButtonCustom(
                                textButton: 'حفظ',
                                onPressed: () async {
                                  if (MissingCubit.get(context)
                                      .formKey
                                      .currentState!
                                      .validate()) {
                                    await MissingCubit.get(context)
                                        .updateStudentMissing(
                                            updateAbsenceStudentBody:
                                                UpdateAbsenceStudentBody(
                                      studentId: getMissingStudentModel.id,
                                      id: getMissingStudentModel
                                          .absences?.last.id,
                                      absenceReason: MissingCubit.get(context)
                                          .reasonTextController
                                          .text,
                                      absenceDate: getMissingStudentModel
                                          .absences?.last.absenceDate,
                                      attendant: getMissingStudentModel
                                          .absences?.last.attendant,
                                    ));
                                    MissingCubit.get(context)
                                        .checkIfDoneAllAbsence(
                                            getMissingStudentModel:
                                                getMissingStudentModel);
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

Widget _customLoadingIndicator() {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    width: 60,
    height: 60,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: ColorManager.colorPrimary, width: 6),
    ),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(ColorManager.colorPrimary),
    ),
  );
}

void absenceReasonHandle(
    {required GetMissingStudentModel getMissingStudentModel,
    required MissingCubit missingCubit}) {
  if (getMissingStudentModel.absences!.last.absenceReason!.isNotEmpty) {
    missingCubit.reasonTextController.text =
        getMissingStudentModel.absences?.last.absenceReason ?? "";
  } else {
    missingCubit.reasonTextController.text = getMissingStudentModel
            .absences![getMissingStudentModel.absences!.length - 2]
            .absenceReason ??
        "";
  }
}
