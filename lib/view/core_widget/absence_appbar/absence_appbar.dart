import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';

import '../../../core/color_manager/color_manager.dart';

class AbsenceAppbar extends StatelessWidget {
  final String text;
  const AbsenceAppbar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(24.r),bottomLeft: Radius.circular(24.r)),
        color: ColorManager.colorPrimary,
      ),
      child: Center(child: Text(text,style: TextStyleManager.textStyle20Bold,)),
    );
  }
}
