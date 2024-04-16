import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/text_manager/text_manager.dart';
import 'package:summer_school_app/view/core_widget/custom_app_bar/custom_App_bar.dart';
import 'package:summer_school_app/view/core_widget/xstation_button_custom/x_station_button_custom.dart';

import '../student_details_widget/student_details_widget.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(title: "Profile"),
      body: const SingleChildScrollView(
        child: StudentDetailsWidget(),
      ),
      bottomNavigationBar:
      Padding(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
        child: XStationButtonCustom(
            textButton: TextManager.update,
        onPressed: (value){},

        ),
      ),
    );
  }
}
