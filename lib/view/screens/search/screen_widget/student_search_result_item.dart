import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/Custom_Text/custom_text.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../core/route_manager/page_name.dart';

class StudentSearchResultItem extends StatelessWidget {
  const StudentSearchResultItem({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        CircleAvatar(
          radius: 27.sp,
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
        InkWell(
            onTap: (){
              Get.toNamed(PageName.studentDetails);
            },
            child: const Icon(
                CupertinoIcons.arrow_right
            )),


      ],
    );
  }
}
