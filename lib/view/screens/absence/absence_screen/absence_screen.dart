import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
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

class _AbsenceScreenState extends State<AbsenceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    AbsenceCubit.get(context).offlineStudentAbsence = [];
    AbsenceCubit.get(context).studentAbsenceModel = [];
    AbsenceCubit.get(context).attendanceCount = 0;
    AbsenceCubit.get(context).absenceLengthOffline = 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorScaffold,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<AbsenceCubit, AbsenceStates>(
              builder: (BuildContext context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modern AppBar
                    const AnimatedAppBar(
                      text: 'الغياب',
                      icon: Icons.event_busy_rounded,
                    ),

                    const SizedBox(height: 16),

                    state is GetClassesNumberLoadingState
                        ? const Center(child: CustomLoading())
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const CustomDropDown(
                                  isAbsence: true,
                                ),
                                const Spacer(),
                                Builder(
                                  builder: (context) {
                                    final int count = AbsenceCubit.get(context)
                                            .isConnected
                                        ? AbsenceCubit.get(context)
                                            .attendanceCount
                                        : AbsenceCubit.get(context)
                                            .absenceLengthOffline;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: ColorManager.colorGreenLight,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color: ColorManager.colorGreen
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: ColorManager.colorGreen,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'الحاضرين: $count',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: ColorManager.colorGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                    const SizedBox(height: 16),

                    AbsenceCubit.get(context).isConnected
                        ? const AbsenceStudentListView()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 24),
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
                                return const SizedBox(
                                  height: 4,
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
