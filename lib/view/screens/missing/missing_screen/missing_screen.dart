import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/utility/database/local/cache_helper.dart';
import 'package:summer_school_app/view/core_widget/absence_appbar/absence_appbar.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';
import 'package:summer_school_app/view_model/repo/missing_repo/missing_repo.dart';

import '../../../../core/service_locator/service_locator.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../../../core_widget/custom_top_sncak_bar/custom_top_snack_bar.dart';
import '../missing_widget/missing_list_view.dart';

class MissingScreen extends StatefulWidget {
  final bool fromStatusMissing;
  final String? numberClass;

  const MissingScreen(
      {super.key, this.fromStatusMissing = false, this.numberClass});

  @override
  State<MissingScreen> createState() => _MissingScreenState();
}

class _MissingScreenState extends State<MissingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

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
    return BlocProvider(
      create: (BuildContext context) => MissingCubit(sl.get<MissingRepo>()),
      child: Scaffold(
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: BlocConsumer<MissingCubit, MissingStates>(
                buildWhen: (previous, current) =>
                    current is GetMissingStudentSuccessState ||
                    current is GetMissingStudentErrorState ||
                    current is GetMissingStudentLoadingState ||
                    current is UpdateStudentMissingSuccessState,
                listener: (context, state) {
                  if (state is CompleteAllStudentMissingSuccessState) {
                    showSnackBarWidget(context,
                        " شكرا لافتقادك يا ${CacheHelper.getDataString(key: 'name')}");
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced AppBar

                      const AnimatedAppBar(
                        text: 'الافتقاد',
                        icon: Icons.search_rounded,
                      ),
                      if (!widget.fromStatusMissing) ...[
                        SizedBox(height: 15.h),
                        const CustomDropDown(
                          isAbsence: false,
                        ),
                      ],
                      SizedBox(height: 20.h),

                      MissingStudentListView(
                        missingCubit: MissingCubit.get(context),
                        state: state,
                        fromStatusMissing: true,
                        numberClass: widget.numberClass,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
