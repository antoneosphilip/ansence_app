import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/color_manager/color_manager.dart';

class ReasonTextFormField extends StatelessWidget {
  const ReasonTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(left: 16.w),
      child: TextFormField(
        cursorColor: ColorManager.colorPrimary,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:  BorderSide(
              color: ColorManager.colorPrimary,
              width: 1.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:  BorderSide(
              color: ColorManager.colorBlack.withOpacity(.5),
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:  BorderSide(
              color: ColorManager.colorPrimary,
              width: 1.w,
            ),
          ),
          hintText: 'سبب الغياب',
          hintStyle: TextStyle(color: ColorManager.colorBlack.withOpacity(.6),),
        ),
        maxLines: null,
        minLines: 5,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
