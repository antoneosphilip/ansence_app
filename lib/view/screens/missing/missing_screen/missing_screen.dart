import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';

import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_app_bar/custom_App_bar.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../../absence/absence_widget/absence_students_list_view.dart';
import '../missing_widget/missing_list_view.dart';

class MissingScreen extends StatelessWidget {
  const MissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AbsenceAppbar(text: 'الافتقاد',),
            SizedBox(height: 15.h),
            const CustomDropDown(),
            SizedBox(height: 20.h),
            const MissingStudentListView(),
          ],
        ),
      ),
    );
  }
}
