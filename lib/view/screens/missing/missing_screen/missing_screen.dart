import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/repo/missing_repo/missing_repo.dart';


import '../../../../core/service_locator/service_locator.dart';
import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_app_bar/custom_App_bar.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../../absence/absence_widget/absence_students_list_view.dart';
import '../missing_widget/missing_list_view.dart';

class MissingScreen extends StatelessWidget {
  const MissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>MissingCubit(sl.get<MissingRepo>()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AbsenceAppbar(text: 'الافتقاد',),
              SizedBox(height: 15.h),
              const CustomDropDown(isAbsence: false,),
              SizedBox(height: 20.h),
              const MissingStudentListView(),
            ],
          ),
        ),
      ),
    );
  }
}
