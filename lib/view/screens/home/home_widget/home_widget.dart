import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/view/screens/missing/missing_screen/missing_screen.dart';


import '../../../core_widget/custom_absece_buttom/custom_absence_buttom.dart';
import '../../absence/absence_screen/absence_screen.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         const Center(
          child: CustomAbsenceButton(text: 'الغياب', screen: AbsenceScreen(),),
        ),
        SizedBox(height: 15.h,),
         const Center(
          child: CustomAbsenceButton(text: 'الافتقاد', screen:  MissingScreen(),transition: Transition.leftToRight,),
        ),
      ],
    );
  }
}
