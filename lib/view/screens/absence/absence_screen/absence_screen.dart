import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/student_item_offline.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<AbsenceCubit,AbsenceStates>(
          // buildWhen: (previous, current) => current is CheckConnectionState,
          builder: (BuildContext context, state) {
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AbsenceAppbar(
                  text: 'الغياب',
                ),
                SizedBox(height: 15.h),
                const CustomDropDown(
                  isAbsence: true,
                ),
                SizedBox(height: 20.h),
                AbsenceCubit.get(context).isConnected
                    ? const AbsenceStudentListView()
                    : Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return StudentAbsenceItemOffline(
                          studentDataOfflineModel: AbsenceCubit.get(context)
                              .offlineStudentAbsence[index],

                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 35.h,
                        );
                      },
                      itemCount: AbsenceCubit.get(context)
                          .offlineStudentAbsence
                          .length),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
