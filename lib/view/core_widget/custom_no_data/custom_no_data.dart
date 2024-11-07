import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 140.0.h),
      child: Column(
        children: [
          Text("لا يوجد طلاب للافتقاد",style: TextStyleManager.textStyle22w800.copyWith(fontWeight: FontWeight.w700,color: ColorManager.colorPrimary),),
          Center(
            child: Lottie.asset('assets/animation/no_data.json',width: 150.w,height: 150.h),
          ),
        ],
      ),
    );
  }
}
