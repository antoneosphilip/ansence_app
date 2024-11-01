import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/model/get_absence_model/get_absence_model.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/color_manager/color_manager.dart';

class StudentAbsenceItem extends StatefulWidget {
  final StudentAbsenceModel studentAbsenceModel;
  const StudentAbsenceItem({super.key, required this.studentAbsenceModel});

  @override
  _StudentAbsenceItemState createState() => _StudentAbsenceItemState();
}

class _StudentAbsenceItemState extends State<StudentAbsenceItem> {
  bool _isAbsent = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
          text: widget.studentAbsenceModel.name!,
          textStyle: TextStyleManager.textStyle20w700.copyWith(color: Colors.black,fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Checkbox(
          activeColor: ColorManager.colorPrimary,
          value: _isAbsent,
          onChanged: (bool? value) {
            setState(() {
              _isAbsent = value ?? false;
            });
          },
        ),
        SizedBox(width: 10.w),
      ],
    );
  }
}
