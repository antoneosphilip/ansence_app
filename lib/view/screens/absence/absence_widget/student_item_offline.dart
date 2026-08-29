import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../../utility/database/local/student.dart';
import '../../../core_widget/custom_Cached_network/cusotm_chaced_netwok.dart';
import '../../../core_widget/show_dialog_image/show_dialog_image.dart';

class StudentAbsenceItemOffline extends StatefulWidget {
  final StudentData studentDataOfflineModel;

  const StudentAbsenceItemOffline({
    super.key,
    required this.studentDataOfflineModel,
  });

  @override
  State<StudentAbsenceItemOffline> createState() =>
      _StudentAbsenceItemOfflineState();
}

class _StudentAbsenceItemOfflineState extends State<StudentAbsenceItemOffline> {
  @override
  Widget build(BuildContext context) {
    final bool isPresent = widget.studentDataOfflineModel.lastAttendance ?? false;
    final String displayName = widget.studentDataOfflineModel.name.isNotEmpty
        ? widget.studentDataOfflineModel.name.split(' ').take(3).join(' ')
        : 'طالب';

    return BlocListener<AbsenceCubit, AbsenceStates>(
      listener: (BuildContext context, state) {
        if (state is UpdateStudentAbsenceErrorState) {
          print("errorUpdate");
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
                if (widget.studentDataOfflineModel.profileImage != null &&
                    widget.studentDataOfflineModel.profileImage!.isNotEmpty) {
                  showImageDialog(
                      context, widget.studentDataOfflineModel.profileImage);
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
                  child: (widget.studentDataOfflineModel.profileImage != null &&
                          widget.studentDataOfflineModel.profileImage!.isNotEmpty)
                      ? CustomCachedImage(
                          imageUrl:
                              widget.studentDataOfflineModel.profileImage)
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
                if (!newValue) {
                  AbsenceCubit.get(context).addAbsenceStudentList(
                      studentData: widget.studentDataOfflineModel);
                } else {
                  AbsenceCubit.get(context).deleteStudentFromList(
                      studentData: widget.studentDataOfflineModel);
                }

                AbsenceCubit.get(context).updateStatistics(
                  classNumber: widget.studentDataOfflineModel.studentClass ?? 0,
                  isAttendant: newValue,
                );

                setState(() {
                  widget.studentDataOfflineModel.lastAttendance = newValue;
                });
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
