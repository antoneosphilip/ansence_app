import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view/screens/absence/absence_screen/absence_screen.dart';
import 'package:summer_school_app/view/screens/missing/missing_screen/missing_screen.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../../utility/database/local/cache_helper.dart';
import '../../../../view_model/block/absence_cubit/absence_cubit.dart';
import '../../../../view_model/block/absence_cubit/absence_states.dart';
import '../../missing/missing_screen/missing_classes_screens.dart';
import '../home_screen/all_classes.dart';
import 'build_shimmer.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    AbsenceCubit.get(context)
        .getClassNumbers(id: CacheHelper.getDataString(key: 'id'));
    AbsenceCubit.get(context)
        .checkMissingClasses(servantId: CacheHelper.getDataString(key: 'id'));
    AbsenceCubit.get(context)
        .getCapacities(servantId: CacheHelper.getDataString(key: 'id'));
    AbsenceCubit.get(context).getClassesFromLocal();
    AbsenceCubit.get(context).getCapacityFromLocal();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 250)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 60 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: onTap,
              child: AnimatedScale(
                scale: 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  height: 240.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      // BoxShadow(
                      //   color: gradientColors[0].withOpacity(0.4),
                      //   blurRadius: 25,
                      //   spreadRadius: 2,
                      //   offset: Offset(0, 12),
                      // ),
                      // BoxShadow(
                      //   color: Colors.black.withOpacity(0.05),
                      //   blurRadius: 15,
                      //   offset: Offset(0, 5),
                      // ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background patterns
                      Positioned(
                        right: -40,
                        top: -40,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -50,
                        bottom: -50,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Decorative dots
                      Positioned(
                        right: 30,
                        bottom: 30,
                        child: Row(
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: EdgeInsets.only(left: 5),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: EdgeInsets.all(28.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'خدمة',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white.withOpacity(0.95),
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'ابدأ الآن',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: gradientColors[0],
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Icon(
                                          Icons.arrow_back,
                                          color: gradientColors[0],
                                          size: 16.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15.w),
                            AnimatedBuilder(
                              animation: _floatingAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatingAnimation.value),
                                  child: Container(
                                    width: 90.w,
                                    height: 90.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                      boxShadow: [],
                                    ),
                                    child: Icon(
                                      icon,
                                      size: 45.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorManager.colorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: ColorManager.colorPrimary,
            size: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.colorPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
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
                  Container(
                    padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 30.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFF8F9FD),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'مرحباً بك 👋',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        ColorManager.colorPrimary,
                                        ColorManager.colorPrimary
                                            .withOpacity(0.7),
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      _getTwoPartName(CacheHelper.getDataString(key: 'name') ?? ""),
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorManager.colorPrimary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.school,
                                          size: 14.sp,
                                          color: ColorManager.colorPrimary,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'مدرسة السمائيين',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: ColorManager.colorPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          ColorManager.colorPrimary,
                                          ColorManager.colorPrimary
                                              .withOpacity(0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [],
                                    ),
                                    child: Icon(
                                      Icons.school_rounded,
                                      color: Colors.white,
                                      size: 32.sp,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<AbsenceCubit, AbsenceStates>(
                    builder: (context, state) {
                      return AbsenceCubit.get(context)
                                      .classStatisticsOfflineResponse !=
                                  null ||
                              AbsenceCubit.get(context).classStatistic != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                children: [
                                  Container(
                                    width: 5.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          ColorManager.colorPrimary,
                                          ColorManager.colorPrimary
                                              .withOpacity(0.5),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'إحصائيات الفصول',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 1200),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: BlocBuilder<AbsenceCubit, AbsenceStates>(
                          builder: (context, state) {
                            final cubit = AbsenceCubit.get(context);

                            final classStatistics =
                                cubit.classStatisticsResponse ??
                                    cubit.classStatisticsOfflineResponse;

                            if (classStatistics == null) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.white,
                                    Colors.grey.shade50
                                  ]),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 30.h,
                                          width: 100.w,
                                          color: Colors.white),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          buildShimmerStatItem(),
                                          buildShimmerStatItem(),
                                          buildShimmerStatItem(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (state is GetCapacityLoadingState) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.white,
                                    Colors.grey.shade50
                                  ]),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 30.h,
                                          width: 100.w,
                                          color: Colors.white),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          buildShimmerStatItem(),
                                          buildShimmerStatItem(),
                                          buildShimmerStatItem(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (state is GetAbsenceErrorState) {
                              showFlutterToast(message: state.error, state: ToastState.ERROR);
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.white,
                                    Colors.grey.shade50
                                  ]),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 30.h,
                                          width: 100.w,
                                          color: Colors.white),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          buildShimmerStatItem(),
                                          buildShimmerStatItem(),
                                          buildShimmerStatItem(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final first = classStatistics.classes.first;

                            return GestureDetector(
                              onTap: () {
                                if (classStatistics.classes.length > 1) {
                                  Get.to(
                                    () => AllClassesStatisticsScreen(
                                      classStatisticsResponse: classStatistics,
                                    ),
                                    transition: Transition.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 500),
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.grey.shade50],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // رأس الفصل
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            ColorManager.colorPrimary,
                                            ColorManager.colorPrimary
                                                .withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.class_,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'فصل ${first?.classNumber ?? 0}',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    // الإحصائيات
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildStatItemColored(
                                          '${first?.capacity ?? 0}',
                                          'سعة الفصل',
                                          Icons.groups,
                                          Colors.blue,
                                        ),
                                        _buildStatItemColored(
                                          '${first?.numberOfAttendants ?? 0}',
                                          'حضور',
                                          Icons.check_circle,
                                          Colors.green,
                                        ),
                                        _buildStatItemColored(
                                          '${first?.numberOfAbsents ?? 0}',
                                          'غياب',
                                          Icons.event_busy,
                                          Colors.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    // شريط نسبة الحضور
                                    Container(
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerRight,
                                        widthFactor: ((first?.capacity ?? 0) >
                                                0)
                                            ? (((first?.numberOfAttendants ??
                                                        0) /
                                                    (first?.capacity ?? 1))
                                                .clamp(0.0, 1.0))
                                            : 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.green,
                                                Colors.green.shade300,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'نسبة الحضور: ${(first?.capacity ?? 0) > 0 ? (((first?.numberOfAttendants ?? 0) / (first?.capacity ?? 1)) * 100).toStringAsFixed(1) : 0}%',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (classStatistics.classes.length > 1)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorManager.colorPrimary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.touch_app,
                                                  size: 14.sp,
                                                  color:
                                                      ColorManager.colorPrimary,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  'عرض الكل',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: ColorManager
                                                        .colorPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    children: [
                      // Section Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            Container(
                              width: 5.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorManager.colorPrimary,
                                    ColorManager.colorPrimary.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'الخدمات الرئيسية',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      _buildFeatureCard(
                        title: 'الغياب',
                        subtitle: 'تسجيل ومتابعة غياب الطلاب',
                        icon: Icons.event_busy_rounded,
                        gradientColors: [
                          ColorManager.colorPrimary,
                          ColorManager.colorPrimary.withOpacity(0.7),
                        ],
                        onTap: () {
                          Get.to(
                            () => AbsenceScreen(),
                            transition: Transition.rightToLeftWithFade,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        index: 0,
                      ),
                      _buildFeatureCard(
                        title: 'الافتقاد',
                        subtitle: 'متابعة الطلاب',
                        icon: Icons.search_rounded,
                        gradientColors: [
                          ColorManager.colorPrimary.withOpacity(0.85),
                          ColorManager.colorPrimary.withOpacity(0.65),
                        ],
                        onTap: () {
                          Get.to(
                            () => MissingScreen(),
                            transition: Transition.leftToRightWithFade,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        index: 1,
                      ),
                      AbsenceCubit.get(context).isConnected &&
                              CacheHelper.getDataString(key: 'role') == 'Admin'
                          ? _buildFeatureCard(
                              title: 'افتقاد الامين',
                              subtitle: 'متابعة الفصول الي تم افتقادها',
                              icon: Icons.assignment_rounded,
                              gradientColors: [
                                ColorManager.colorPrimary.withOpacity(0.85),
                                ColorManager.colorPrimary.withOpacity(0.65),
                              ],
                              onTap: () {
                                Get.to(
                                  () => MissingClassesScreen(),
                                  transition: Transition.rightToLeftWithFade,
                                  duration: Duration(milliseconds: 500),
                                );
                              },
                              index: 1,
                            )
                          : SizedBox(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItemColored(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
String _getTwoPartName(String fullName) {
  final parts = fullName.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0]} ${parts[1]}'; // أول اسمين فقط
  } else {
    return fullName; // لو الاسم كلمة واحدة
  }
}