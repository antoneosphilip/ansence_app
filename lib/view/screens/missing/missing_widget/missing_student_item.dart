import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/view/screens/student_profile/student_profile_screen/student_profile.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../model/get_missing_student_model/get_missing_student_model.dart';

class MissingStudentItem extends StatelessWidget {
  final GetMissingStudentModel studentMissingModel;

  const MissingStudentItem({super.key, required this.studentMissingModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
           StudentProfile(getMissingStudentModel: studentMissingModel,),
          transition: Transition.zoom,
          duration: const Duration(milliseconds: 350),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 16.w),
          Container(
            width: 50.w,
            height: 50.h,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/images/default_image.jpg'))),
          ),
          SizedBox(width: 10.w),
          TextWidget(
            text: studentMissingModel.name,
            textStyle: TextStyleManager.textStyle20w700
                .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          studentMissingModel.absences.last.absenceReason.isNotEmpty
              ? const Icon(
                  Icons.check,
                  color: ColorManager.colorPrimary,
                )
              : const SizedBox(),
          SizedBox(
            width: 16.w,
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}
