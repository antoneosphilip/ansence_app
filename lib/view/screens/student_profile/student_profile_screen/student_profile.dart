import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/model/update_absence_student/update_absence_student_body.dart';
import 'package:summer_school_app/utility/database/local/cache_helper.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
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

  const StudentProfile({
    super.key,
    required this.getMissingStudentModel,
    required this.missingCubit,
    required this.numberClass,
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String role = "";

  @override
  void initState() {
    super.initState();
    role = CacheHelper.getDataString(key: 'role') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    absenceReasonHandle(
      getMissingStudentModel: widget.getMissingStudentModel,
      missingCubit: widget.missingCubit,
    );

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
            if (role == 'Admin') {
              AbsenceCubit.get(context).checkMissingClasses(
                  servantId: CacheHelper.getDataString(key: 'id') ?? '');
            }
          } else if (state is UpdateStudentMissingErrorState) {
            EasyLoading.dismiss();
            showFlutterToast(
                message: "حدث خطأ في الحفظ حاول لاحقاً",
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
                backgroundColor: ColorManager.colorScaffold,
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),

                      // Attendance Status Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorManager.colorWhite,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: ColorManager.cardShadow,
                            border: Border.all(
                              color: ColorManager.colorGrey4,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: ColorManager.colorPrimary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'حالة الحضور في المواد',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.colorDarkBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildAttendanceItem(
                                'قبطي',
                                widget.getMissingStudentModel.student.absences
                                        ?.last.copticAttendant ??
                                    false,
                              ),
                              const SizedBox(height: 10),
                              _buildAttendanceItem(
                                'ألحان',
                                widget.getMissingStudentModel.student.absences
                                        ?.last.alhanAttendant ??
                                    false,
                              ),
                              const SizedBox(height: 10),
                              _buildAttendanceItem(
                                'طقس',
                                widget.getMissingStudentModel.student.absences
                                        ?.last.tacsAttendant ??
                                    false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Absence Reason Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorManager.colorWhite,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: ColorManager.cardShadow,
                            border: Border.all(
                              color: ColorManager.colorGrey4,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: ColorManager.colorGold,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'سبب الغياب / المتابعة',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.colorDarkBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const ReasonTextFormField(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Quick Contact Actions
                      CallButtons(
                        getMissingStudentModel:
                            widget.getMissingStudentModel,
                      ),

                      const SizedBox(height: 28),

                      // Save Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: GradiantLinearColor.primaryGradiant,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: ColorManager.glowShadow(
                                ColorManager.colorPrimary),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (MissingCubit.get(context)
                                  .formKey
                                  .currentState!
                                  .validate()) {
                                await MissingCubit.get(context)
                                    .updateStudentMissing(
                                  updateAbsenceStudentBody:
                                      UpdateAbsenceStudentBody(
                                    studentId: widget
                                        .getMissingStudentModel.student.id,
                                    id: widget.getMissingStudentModel.student
                                        .absences?.last.id,
                                    absenceReason: MissingCubit.get(context)
                                        .reasonTextController
                                        .text,
                                    absenceDate: widget.getMissingStudentModel
                                        .student.absences?.last.absenceDate,
                                    attendant: widget.getMissingStudentModel
                                        .student.absences?.last.attendant,
                                  ),
                                );
                                MissingCubit.get(context)
                                    .checkIfDoneAllAbsence(
                                  getMissingStudentModel:
                                      widget.getMissingStudentModel,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'حفظ التقرير',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final student = widget.getMissingStudentModel.student;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: GradiantLinearColor.primaryGradiant,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        boxShadow: ColorManager.glowShadow(ColorManager.colorPrimary),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const Spacer(),
                const Text(
                  'بيانات الطالب',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 16),

            // Avatar with white border
            GestureDetector(
              onTap: () => showImageDialog(
                context,
                widget.getMissingStudentModel.student.profileImage,
              ),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.getMissingStudentModel.student.profileImage !=
                              null &&
                          widget.getMissingStudentModel.student.profileImage!
                              .isNotEmpty
                      ? CustomCachedImage(
                          imageUrl: widget
                              .getMissingStudentModel.student.profileImage)
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              student.studentName.isNotEmpty
                                  ? student.studentName.substring(0, 1)
                                  : 'ط',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.colorPrimary,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              student.studentName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'فصل ${student.studentClass ?? ""}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_busy_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${student.numberOfAbsences} غياب',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(String subject, bool isPresent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isPresent
            ? ColorManager.colorGreenLight
            : ColorManager.colorRedLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPresent
              ? ColorManager.colorGreen.withOpacity(0.2)
              : ColorManager.colorRed.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: TextStyle(
              color: isPresent
                  ? ColorManager.colorGreen
                  : ColorManager.colorRed,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPresent ? ColorManager.colorGreen : ColorManager.colorRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPresent
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  isPresent ? 'حاضر' : 'غائب',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _customLoadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(ColorManager.colorPrimary),
  );
}

void absenceReasonHandle({
  required GetMissingStudentModelAbsenceModel getMissingStudentModel,
  required MissingCubit missingCubit,
}) {
  if (getMissingStudentModel.student.absences != null &&
      getMissingStudentModel.student.absences!.isNotEmpty &&
      getMissingStudentModel.student.absences!.last.absenceReason != null &&
      getMissingStudentModel.student.absences!.last.absenceReason!.isNotEmpty) {
    missingCubit.reasonTextController.text =
        getMissingStudentModel.student.absences?.last.absenceReason ?? "";
  } else if (getMissingStudentModel.student.absences != null &&
      getMissingStudentModel.student.absences!.length > 1) {
    missingCubit.reasonTextController.text = getMissingStudentModel
            .student
            .absences![getMissingStudentModel.student.absences!.length - 2]
            .absenceReason ??
        "";
  } else {
    missingCubit.reasonTextController.text = "";
  }
}