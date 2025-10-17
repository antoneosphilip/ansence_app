import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/model/update_absence_student/update_absence_student_body.dart';
import 'package:summer_school_app/utility/database/local/cache_helper.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view/core_widget/xstation_button_custom/x_station_button_custom.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';

import '../../../../model/get_missing_student_model/get_missing_student_model.dart';
import '../../../core_widget/custom_Cached_network/cusotm_chaced_netwok.dart';
import '../../../core_widget/show_dialog_image/show_dialog_image.dart';
import '../student_profile_widget/call_buttons.dart';
import '../student_profile_widget/reason_text_form_field.dart';

class StudentProfile extends StatefulWidget {
  final GetMissingStudentModelAbsenceModel getMissingStudentModel;
  final MissingCubit missingCubit;
  final String numberClass;

  const StudentProfile(
      {super.key,
        required this.getMissingStudentModel,
        required this.missingCubit, required this.numberClass});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String role="";
  @override
  void initState() {
    // TODO: implement initState
    role=CacheHelper.getDataString(key: 'role');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    absenceReasonHandle(
        getMissingStudentModel: widget.getMissingStudentModel,
        missingCubit: widget.missingCubit);
    return BlocProvider.value(
        value: widget.missingCubit,
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
              if(role=='Admin'){
                print("updateee");
                AbsenceCubit.get(context).checkMissingClasses(servantId: CacheHelper.getDataString(key: 'id'));

              }
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
                  backgroundColor: Colors.grey[50],
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(context),

                              SizedBox(height: 25.h),

                              // Attendance Status Card
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorManager.colorPrimary.withOpacity(0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'حالة الحضور',
                                        style: TextStyleManager.textStyle20w500.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: ColorManager.colorPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      _buildAttendanceItem(
                                        'قبطي',
                                        widget.getMissingStudentModel.student.absences?.last.copticAttendant ?? false,
                                      ),
                                      SizedBox(height: 12.h),
                                      _buildAttendanceItem(
                                        'ألحان',
                                        widget.getMissingStudentModel.student.absences?.last.alhanAttendant ?? false,
                                      ),
                                      SizedBox(height: 12.h),
                                      _buildAttendanceItem(
                                        'طقس',
                                        widget.getMissingStudentModel.student.absences?.last.tacsAttendant ?? false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),



                              SizedBox(height: 20.h),

                              // Absence Reason Card
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: ColorManager.colorPrimary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Icon(
                                              Icons.info_outline,
                                              color: ColorManager.colorPrimary,
                                              size: 24.sp,
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            'سبب الغياب',
                                            style: TextStyleManager.textStyle20w500.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      const ReasonTextFormField(),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 25.h),

                              CallButtons(
                                getMissingStudentModel: widget.getMissingStudentModel,
                              ),
                              SizedBox(height: 120.h),
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
                                            studentId: widget.getMissingStudentModel.student.id,
                                            id: widget.getMissingStudentModel.student
                                                .absences?.last.id,
                                            absenceReason: MissingCubit.get(context)
                                                .reasonTextController
                                                .text,
                                            absenceDate: widget.getMissingStudentModel.student
                                                .absences?.last.absenceDate,
                                            attendant: widget.getMissingStudentModel.student
                                                .absences?.last.attendant,
                                          ));
                                      MissingCubit.get(context)
                                          .checkIfDoneAllAbsence(
                                          getMissingStudentModel:
                                          widget.getMissingStudentModel);
                                    }
                                  }),
                            ),
                          ),
                          SizedBox(height: 80.h),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildHeader(BuildContext context) {
    final student = widget.getMissingStudentModel.student;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.colorPrimary,
            ColorManager.colorPrimary.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.colorPrimary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  'بيانات الطالب',
                  style: TextStyleManager.textStyle22w800.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                SizedBox(width: 48.w),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          GestureDetector(
            onTap: () => showImageDialog(
              context,
              widget.getMissingStudentModel.student.profileImage,
            ),
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: widget.getMissingStudentModel.student.profileImage != null
                    ? CustomCachedImage(
                    imageUrl: widget.getMissingStudentModel.student.profileImage)
                    : Image.asset(
                  'assets/images/default_image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            student.studentName,
            style: TextStyleManager.textStyle22w800.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.class_, color: Colors.white, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'فصل ${student.studentClass ?? ""}',
                      style: TextStyleManager.textStyle14w500.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_busy, color: Colors.white, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(
                      '${student.numberOfAbsences} غياب',
                      style: TextStyleManager.textStyle14w500.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String subject, bool isPresent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.colorPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.colorPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: TextStyleManager.textStyle18w500.copyWith(
              color: ColorManager.colorPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isPresent
                  ? ColorManager.colorPrimary
                  : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPresent ? Icons.check : Icons.close,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
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

void absenceReasonHandle({
  required GetMissingStudentModelAbsenceModel getMissingStudentModel,
  required MissingCubit missingCubit,
}) {
  if (getMissingStudentModel.student.absences!.last.absenceReason!.isNotEmpty) {
    missingCubit.reasonTextController.text =
        getMissingStudentModel.student.absences?.last.absenceReason ?? "";
  } else if (getMissingStudentModel.student.absences!.length > 1) {
    missingCubit.reasonTextController.text = getMissingStudentModel.student
        .absences![
    getMissingStudentModel.student.absences!.length - 2].absenceReason ??
        "";
  } else {
    missingCubit.reasonTextController.text = "";
  }
}