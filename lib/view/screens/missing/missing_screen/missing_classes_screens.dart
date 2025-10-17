import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:summer_school_app/view/core_widget/absence_appbar/absence_appbar.dart';
import 'package:summer_school_app/view/core_widget/custom_error/custom_error.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../../utility/database/local/cache_helper.dart';
import '../missing_widget/missing_classes_widget.dart';

// استخدم هذا الكود في صفحة عرض الفصول
class MissingClassesScreen extends StatefulWidget {
  const MissingClassesScreen({super.key});

  @override
  State<MissingClassesScreen> createState() => _MissingClassesScreenState();
}

class _MissingClassesScreenState extends State<MissingClassesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    AbsenceCubit.get(context).checkMissingClasses(servantId: CacheHelper.getDataString(key: 'id'));

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
      backgroundColor: Color(0xFFF8F9FD),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Header
                  const AnimatedAppBar(text: 'حالة الافتقاد',icon: Icons.event_busy_rounded,),

                  SizedBox(height: 20.h),

                  // Missing Classes Widget
                  BlocBuilder<AbsenceCubit,AbsenceStates>(
                    builder: (BuildContext context, state) {
                      return
                        state is GetMissingClassesLoadingState?
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child:const MissingClassesWidget(
                          classesData:{
                            '0':true
                          }
                        )
                      ):
                            state is GetMissingClassesErrorState?
                        const CustomError():
                        MissingClassesWidget(
                        classesData:
                        AbsenceCubit.get(context)
                            .numbersMissingClassesModel
                            ?.items ??
                            {},
                      );
                    },

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// أو استخدمه مباشرة في أي مكان:
// ============================================

Widget buildMissingClassesSection(BuildContext context) {
  return MissingClassesWidget(
    classesData: AbsenceCubit.get(context).numbersMissingClassesModel?.items ?? {},
  );
}

// ============================================
// مثال على البيانات:
// ============================================
/*
{
  "الفصل الأول": true,
  "الفصل الثاني": false,
  "الفصل الثالث": true,
  "الفصل الرابع": false,
  "الفصل الخامس": true,
}
*/