import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/Custom_Text/custom_text.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/view/core_widget/text_form_field/text_form_field_custom.dart';

class SearchScreenWidget extends StatelessWidget {
  const SearchScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
      child: Column(
        children: [
          TextFormFieldCustom(
            validate: (String? value)
            {
            },
            hint: "Search for a student",
            suffix: true,
            suffixIcon: const Icon(Icons.search),


          ),
          SizedBox(height: 20.h,),
          Row(
            children: [
              CircleAvatar(
                radius: 25.sp,
                backgroundImage: const NetworkImage('https://th.bing.com/th/id/OIP.j8yd8dJ5215WbgQ0NsLzuAHaNK?rs=1&pid=ImgDetMain'),
              ),
              SizedBox(width: 10.w,),
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(text: "name",textStyle: Theme.of(context).textTheme.bodyLarge!,),
                  TextWidget(text: "address", textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15.sp,color: ColorManager.colorGrey)!,),

                ],
              ),
              const Spacer(),
              const Icon(CupertinoIcons.arrow_right),


            ],
          )

        ],
      ),
    );
  }
}
