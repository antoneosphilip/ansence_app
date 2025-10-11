// ============= Absence Screen =============
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/student_item_offline.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';
import 'package:get/get.dart';

import '../../../../view_model/block/absence_cubit/absence_cubit.dart';
import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../absence_widget/absence_students_list_view.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    AbsenceCubit.get(context).offlineStudentAbsence = [];
    AbsenceCubit.get(context).studentAbsenceModel = [];
    AbsenceCubit.get(context).attendanceCount = 0;
    AbsenceCubit.get(context).absenceLengthOffline = 0;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: BlocBuilder<AbsenceCubit, AbsenceStates>(
              builder: (BuildContext context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced AppBar
                    const AnimatedAppBar(text: 'الغياب',icon: Icons.event_busy_rounded,),

                    SizedBox(height: 15.h),

                    state is GetClassesNumberLoadingState
                        ? Center(child: CustomLoading())
                        : AbsenceCubit.get(context).isConnected
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
                              style: TextStyleManager
                                  .textStyle20w500
                                  .copyWith(fontSize: 13.sp),
                            ),
                            Text(
                              AbsenceCubit.get(context)
                                  .attendanceCount
                                  .toString(),
                              style: TextStyleManager
                                  .textStyle20w500
                                  .copyWith(
                                fontSize: 13.sp,
                                color:
                                ColorManager.colorPrimary,
                              ),
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
                        AbsenceCubit.get(context)
                            .absenceLengthOffline ==
                            0
                            ? const SizedBox()
                            : Row(
                          children: [

                            Text(
                              "عدد الطلاب الحاضرين : ",
                              style: TextStyleManager
                                  .textStyle20w500
                                  .copyWith(fontSize: 13.sp),
                            ),

                            Text(
                              AbsenceCubit.get(context)
                                  .absenceLengthOffline
                                  .toString(),
                              style: TextStyleManager
                                  .textStyle20w500
                                  .copyWith(
                                fontSize: 13.sp,
                                color:
                                ColorManager.colorPrimary,
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                          ],
                        ),
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
                            .length,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
