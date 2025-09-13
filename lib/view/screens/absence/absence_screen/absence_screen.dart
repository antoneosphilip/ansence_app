import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/student_item_offline.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../view_model/block/absence_cubit/absence_cubit.dart';
import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../absence_widget/absence_students_list_view.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    AbsenceCubit.get(context)
        .offlineStudentAbsence=[];
    AbsenceCubit.get(context)
        .studentAbsenceModel=[];
    AbsenceCubit.get(context)
        .attendanceCount=0;
    AbsenceCubit.get(context)
        .absenceLengthOffline=0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<AbsenceCubit, AbsenceStates>(
          // buildWhen: (previous, current) => current is CheckConnectionState,
          builder: (BuildContext context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AbsenceAppbar(
                  text: 'الغياب',
                ),
                SizedBox(height: 15.h),
                AbsenceCubit.get(context).isConnected
                    ? Row(
                        children: [
                          const CustomDropDown(
                            isAbsence: true,
                          ),
                          const Spacer(),
                          AbsenceCubit.get(context).attendanceCount == 0
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Text(
                                      "عدد الطلاب الحاضرين : ",
                                      style: TextStyleManager.textStyle20w500
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                    Text(
                                      AbsenceCubit.get(context)
                                          .attendanceCount
                                          .toString(),
                                      style: TextStyleManager.textStyle20w500
                                          .copyWith(
                                              fontSize: 13.sp,
                                              color: ColorManager.colorPrimary),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                  ],
                                )
                        ],
                      )
                    : Row(
                        children: [
                          const CustomDropDown(
                            isAbsence: true,
                          ),
                          const Spacer(),
                          AbsenceCubit.get(context).absenceLengthOffline == 0
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Text(
                                      "عدد الطلاب الحاضرين : ",
                                      style: TextStyleManager.textStyle20w500
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                    Text(
                                      AbsenceCubit.get(context)
                                          .absenceLengthOffline
                                          .toString(),
                                      style: TextStyleManager.textStyle20w500
                                          .copyWith(
                                              fontSize: 13.sp,
                                              color: ColorManager.colorPrimary),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                  ],
                                )
                        ],
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
                                studentDataOfflineModel:
                                    AbsenceCubit.get(context)
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
