import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/color_manager/color_manager.dart';
import '../../../view_model/block/missing_cubit/missing_cubit.dart';

class CallButtonWhatsapp extends StatelessWidget {
  final Function() onTab;
  final String text;
  final String svg;
  const CallButtonWhatsapp({super.key, required this.onTab, required this.text, required this.svg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity, // Full width if needed
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorManager.colorPrimary, // Background color
          borderRadius:
          BorderRadius.circular(24.r), // Rounded corners
        ),
        child: InkWell(
          onTap:onTab,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(svg,width: 23.w,height: 23.h,color: Colors.white,),
              SizedBox(width: 8.w), // Space between icon and text
               Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
