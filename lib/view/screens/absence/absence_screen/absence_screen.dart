import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view_model/repo/absence_repo/absence.dart';

import '../../../../core/service_locator/service_locator.dart';
import '../../../../view_model/block/absence_cubit/absence_cubit.dart';
import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../absence_widget/absence_students_list_view.dart';

class AbsenceScreen extends StatelessWidget {
  const AbsenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AbsenceCubit(sl.get<AbsenceRepo>()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AbsenceAppbar(
                text: 'الغياب',
              ),
              SizedBox(height: 15.h),
              const CustomDropDown(),
              SizedBox(height: 20.h),
              const AbsenceStudentListView(),
            ],
          ),
        ),
      ),
    );
  }
}
