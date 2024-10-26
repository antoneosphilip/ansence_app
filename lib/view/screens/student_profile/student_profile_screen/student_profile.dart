import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/view/core_widget/absence_appbar/absence_appbar.dart';
import 'package:summer_school_app/view/core_widget/xstation_button_custom/x_station_button_custom.dart';
import 'package:summer_school_app/view/screens/student_profile/student_profile_widget/call_button_item.dart';

import '../student_profile_widget/call_buttons.dart';
import '../student_profile_widget/reason_text_form_field.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      padding:  EdgeInsets.only(bottom: 35.h),
                      child: const AbsenceAppbar(text: 'الاسم'),
                    ),
                    Container(
                      width: 75.w,
                      height: 75.h,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage('https://st2.depositphotos.com/4111759/12123/v/950/depositphotos_121231710-stock-illustration-male-default-avatar-profile-gray.jpg'))
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h,),
                Padding(
                  padding:  EdgeInsets.only(right: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('الأسم :',style: TextStyleManager.textStyle22w800,),
                          Text(' أنطونيوس',style: TextStyleManager.textStyle20w500.copyWith(color: ColorManager.colorPrimary),),
                        ],
                      ),
                      SizedBox(height: 15.h,),
                      Row(
                        children: [
                          Text('الفصل :',style: TextStyleManager.textStyle20w500.copyWith(fontWeight: FontWeight.w800),),
                          Text(' 7',style: TextStyleManager.textStyle20w500.copyWith(color: ColorManager.colorPrimary),),

                        ],
                      ),
                      SizedBox(height: 20.h,),
                      const ReasonTextFormField(),

                    ],
                  ),
                ),
                SizedBox(height: 30.h,),
                const CallButtons(),
                SizedBox(height: 180.h,),
              ],
            ),
            Center(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.w),
                child: AbsenceButtonCustom(textButton: 'حفظ', onPressed:(){} ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
