import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';
import 'package:summer_school_app/model/update_absence_student/update_absence_student_body.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../core_widget/custom_Cached_network/cusotm_chaced_netwok.dart';
import '../../../core_widget/show_dialog_image/show_dialog_image.dart';

class StudentAbsenceItem extends StatefulWidget {
  final Student studentAbsenceModel;

  const StudentAbsenceItem({super.key, required this.studentAbsenceModel});

  @override
  State<StudentAbsenceItem> createState() => _StudentAbsenceItemState();
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
    final bool isPresent = _studentModel.lastAttendance ?? false;
    final String displayName = _studentModel.studentName != null
        ? _studentModel.studentName!.split(' ').take(3).join(' ')
        : 'طالب';

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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: ColorManager.softShadow,
          border: Border.all(
            color: isPresent
                ? ColorManager.colorGreen.withOpacity(0.2)
                : ColorManager.colorGrey4,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Student Profile Image / Avatar with status border
            GestureDetector(
              onTap: () {
                if (_studentModel.profileImage != null &&
                    _studentModel.profileImage!.isNotEmpty) {
                  showImageDialog(context, _studentModel.profileImage);
                }
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPresent
                        ? ColorManager.colorGreen
                        : ColorManager.colorRed.withOpacity(0.6),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: (_studentModel.profileImage != null &&
                          _studentModel.profileImage!.isNotEmpty)
                      ? CustomCachedImage(imageUrl: _studentModel.profileImage)
                      : Container(
                          color: ColorManager.colorPrimary.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              displayName.isNotEmpty
                                  ? displayName.substring(0, 1)
                                  : 'ط',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.colorPrimary,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Student Name & Status Badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.colorDarkBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPresent
                          ? ColorManager.colorGreenLight
                          : ColorManager.colorRedLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPresent ? 'حاضر ✓' : 'غائب ✗',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isPresent
                            ? ColorManager.colorGreen
                            : ColorManager.colorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Interactive Attendance Switch / Pill
            InkWell(
              onTap: () {
                final bool newValue = !isPresent;
                final lastAbsence = _studentModel.absences?.last;

                if (lastAbsence != null) {
                  AbsenceCubit.get(context).updateStudentAbsence(
                    updateAbsenceStudentBody: UpdateAbsenceStudentBody(
                      id: lastAbsence.id,
                      studentId: lastAbsence.studentId,
                      absenceDate: lastAbsence.absenceDate,
                      absenceReason: lastAbsence.absenceReason ?? '',
                      attendant: newValue,
                      alhanAttendant: !lastAbsence.alhanAttendant,
                      copticAttendant: !lastAbsence.copticAttendant,
                      tacsAttendant: !lastAbsence.tacsAttendant,
                      student: lastAbsence.student != null
                          ? Student(
                              id: lastAbsence.student!.id,
                              studentName: lastAbsence.student!.name,
                              classId: lastAbsence.student!.classId,
                              lastAttendance: newValue,
                            )
                          : null,
                    ),
                  );
                }

                AbsenceCubit.get(context).updateStatistics(
                  classNumber: _studentModel.studentClass ?? 0,
                  isAttendant: newValue,
                );

                setState(() {
                  _studentModel = _studentModel.copyWith(
                    lastAttendance: newValue,
                  );
                });

                AbsenceCubit.get(context).changeAbsence(
                  isValue: newValue,
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isPresent
                      ? ColorManager.colorGreen
                      : ColorManager.colorGrey4,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isPresent
                      ? ColorManager.glowShadow(ColorManager.colorGreen)
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPresent
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isPresent
                          ? Colors.white
                          : ColorManager.colorXXGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isPresent ? 'حاضر' : 'تحضير',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPresent
                            ? Colors.white
                            : ColorManager.colorDarkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
