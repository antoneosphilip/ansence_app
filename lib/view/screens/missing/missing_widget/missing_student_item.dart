import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/view/screens/student_profile/student_profile_screen/student_profile.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../../model/get_missing_student_model/get_missing_student_model.dart';
import '../../../core_widget/custom_Cached_network/cusotm_chaced_netwok.dart';
import '../../../core_widget/show_dialog_image/show_dialog_image.dart';

class MissingStudentItem extends StatelessWidget {
  final GetMissingStudentModelAbsenceModel studentMissingModel;
  final MissingCubit missingCubit;
  final String numberClass;

  const MissingStudentItem({
    super.key,
    required this.studentMissingModel,
    required this.missingCubit,
    required this.numberClass,
  });

  @override
  Widget build(BuildContext context) {
    final String displayName = studentMissingModel.student.studentName ?? 'طالب';
    final bool hasFollowedUp = (studentMissingModel.student.absences != null &&
        studentMissingModel.student.absences!.isNotEmpty &&
        studentMissingModel.student.absences!.last.absenceReason != null &&
        studentMissingModel.student.absences!.last.absenceReason!.isNotEmpty);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: ColorManager.softShadow,
        border: Border.all(
          color: hasFollowedUp
              ? ColorManager.colorGreen.withOpacity(0.3)
              : ColorManager.colorGold.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.to(
            () => StudentProfile(
              getMissingStudentModel: studentMissingModel,
              missingCubit: missingCubit,
              numberClass: numberClass,
            ),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 350),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Profile Image
              GestureDetector(
                onTap: () {
                  if (studentMissingModel.student.profileImage != null &&
                      studentMissingModel.student.profileImage!.isNotEmpty) {
                    showImageDialog(
                      context,
                      studentMissingModel.student.profileImage,
                    );
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasFollowedUp
                          ? ColorManager.colorGreen
                          : ColorManager.colorGold,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: (studentMissingModel.student.profileImage != null &&
                            studentMissingModel.student.profileImage!.isNotEmpty)
                        ? CustomCachedImage(
                            imageUrl:
                                studentMissingModel.student.profileImage)
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

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.split(' ').take(3).join(' '),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: hasFollowedUp
                            ? ColorManager.colorGreenLight
                            : ColorManager.colorGoldLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasFollowedUp
                                ? Icons.check_circle_rounded
                                : Icons.schedule_rounded,
                            size: 12,
                            color: hasFollowedUp
                                ? ColorManager.colorGreen
                                : ColorManager.colorGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasFollowedUp ? 'تم الافتقاد' : 'بحاجة لافتقاد',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: hasFollowedUp
                                  ? ColorManager.colorGreen
                                  : ColorManager.colorGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Arrow
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ColorManager.colorPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: ColorManager.colorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
