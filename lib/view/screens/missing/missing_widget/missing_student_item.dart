import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/view/screens/student_profile/student_profile_screen/student_profile.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/color_manager/color_manager.dart';

class MissingStudentItem extends StatelessWidget {
  const MissingStudentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(const StudentProfile(),
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
                image: DecorationImage(image: NetworkImage('https://st2.depositphotos.com/4111759/12123/v/950/depositphotos_121231710-stock-illustration-male-default-avatar-profile-gray.jpg'))
            ),
          ),
          SizedBox(width: 10.w),
          TextWidget(
            text: "الاسم",
            textStyle: TextStyleManager.textStyle20w700.copyWith(color: Colors.black,fontWeight: FontWeight.w600),
          ),

          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}
