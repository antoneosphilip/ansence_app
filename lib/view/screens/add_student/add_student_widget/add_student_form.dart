import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/text_manager/text_manager.dart';
import '../../../core_widget/text_form_field/text_form_field_custom.dart';

class AddStudentForm extends StatelessWidget {
  const AddStudentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(text: TextManager.name, textStyle: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(height: 10.h,),
          TextFormFieldCustom(
            validate: (value){},
            hint: TextManager.name,
          ),
          SizedBox(height: 35.h,),
          TextWidget(text: TextManager.address, textStyle: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(height: 10.h,),
          TextFormFieldCustom(
            validate: (value){},
            hint: TextManager.address,
          ),
          SizedBox(height: 35.h,),
          TextWidget(text: TextManager.phone, textStyle: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(height: 10.h,),
          TextFormFieldCustom(
            validate: (value){},
            hint: TextManager.phone,
          ),
          SizedBox(height: 35.h,),
          TextWidget(text: TextManager.age, textStyle: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(height: 10.h,),
          TextFormFieldCustom(
            validate: (value){},
            hint: TextManager.age,
          ),


        ],
      ),
    );
  }
}
