import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';


import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_absece_buttom/custom_absence_buttom.dart';
import '../../absence/absence_screen/absence_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            const AbsenceAppbar(
              text: "الاعدادات",
            ),
            SizedBox(height: 50.h,),
            CustomAbsenceButton(text: 'تحميل الداتا',onPressed: () {
              AbsenceCubit.get(context).getAllAbsence();
            }, )
          ],
        ),
      ),
    );
  }
}
