import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final servantId = CacheHelper.getDataString(key: 'id') ?? '';
    final cubit = AbsenceCubit.get(context);
    cubit.getClassNumbers(id: servantId);
    cubit.checkMissingClasses(servantId: servantId);
    cubit.getCapacities(servantId: servantId);
    cubit.getClassesFromLocal();
    cubit.getCapacityFromLocal();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
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

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String tag,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Ambient decorative circle
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String servantName =
        _getTwoPartName(CacheHelper.getDataString(key: 'name') ?? 'الخادم');

    return Scaffold(
      backgroundColor: ColorManager.colorScaffold,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern Header Section
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    decoration: const BoxDecoration(
                      color: ColorManager.colorWhite,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0a0f172a),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Servant Avatar
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: GradiantLinearColor.primaryGradiant,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: ColorManager.glowShadow(
                                    ColorManager.colorPrimary),
                              ),
                              child: Center(
                                child: Text(
                                  servantName.isNotEmpty
                                      ? servantName.substring(0, 1)
                                      : 'خ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Welcome Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'مرحباً بك 👋',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: ColorManager.colorXXGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    servantName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.colorDarkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Church/App Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: ColorManager.colorPrimary
                                    .withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ColorManager.colorPrimary
                                      .withOpacity(0.18),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.school_rounded,
                                    size: 16,
                                    color: ColorManager.colorPrimary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'السمائيين',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorManager.colorPrimary,
                                      fontWeight: FontWeight.bold,
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

                  const SizedBox(height: 24),

                  // Class Statistics Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: ColorManager.colorPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'إحصائيات الفصول',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.colorDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Statistics Card
                  BlocBuilder<AbsenceCubit, AbsenceStates>(
                    builder: (context, state) {
                      final cubit = AbsenceCubit.get(context);
                      final classStatistics =
                          cubit.classStatisticsResponse ??
                              cubit.classStatisticsOfflineResponse;

                      if (classStatistics == null ||
                          state is GetCapacityLoadingState) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorManager.colorWhite,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: ColorManager.cardShadow,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade200,
                            highlightColor: Colors.grey.shade50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildShimmerStatItem(),
                                buildShimmerStatItem(),
                                buildShimmerStatItem(),
                              ],
                            ),
                          ),
                        );
                      }

                      final first = classStatistics.classes.isNotEmpty
                          ? classStatistics.classes.first
                          : null;

                      final int capacity = first?.capacity ?? 0;
                      final int attendants = first?.numberOfAttendants ?? 0;
                      final int absents = first?.numberOfAbsents ?? 0;
                      final double attendanceRate =
                          capacity > 0 ? (attendants / capacity) : 0.0;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: ColorManager.colorWhite,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: ColorManager.cardShadow,
                          border: Border.all(
                            color: ColorManager.colorGrey4,
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (classStatistics.classes.length > 1) {
                              Get.to(
                                () => AllClassesStatisticsScreen(
                                  classStatisticsResponse: classStatistics,
                                ),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 400),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: ColorManager.colorPrimary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'فصل ${first?.classNumber ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.colorPrimary,
                                        ),
                                      ),
                                    ),
                                    if (classStatistics.classes.length > 1)
                                      Row(
                                        children: [
                                          Text(
                                            'عرض الكل (${classStatistics.classes.length})',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: ColorManager.colorPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: ColorManager.colorPrimary,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Metric Badges
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem(
                                      '$capacity',
                                      'سعة الفصل',
                                      Icons.groups_rounded,
                                      ColorManager.colorBlue,
                                      ColorManager.colorBlue.withOpacity(0.1),
                                    ),
                                    _buildStatItem(
                                      '$attendants',
                                      'حضور',
                                      Icons.check_circle_rounded,
                                      ColorManager.colorGreen,
                                      ColorManager.colorGreenLight,
                                    ),
                                    _buildStatItem(
                                      '$absents',
                                      'غياب',
                                      Icons.cancel_rounded,
                                      ColorManager.colorRed,
                                      ColorManager.colorRedLight,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // Progress Bar
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'نسبة الحضور',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ColorManager.colorXXGrey,
                                          ),
                                        ),
                                        Text(
                                          '${(attendanceRate * 100).toStringAsFixed(1)}%',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: ColorManager.colorDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: attendanceRate.clamp(0.0, 1.0),
                                        minHeight: 8,
                                        backgroundColor:
                                            ColorManager.colorGrey4,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                ColorManager.colorGreen),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // Quick Action Services
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: ColorManager.colorPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'الخدمات الرئيسية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.colorDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Feature Cards
                  _buildFeatureCard(
                    title: 'تسجيل الغياب',
                    subtitle: 'تسجيل ومتابعة حضور وغياب الطلاب',
                    tag: 'الخدمة الأساسية',
                    icon: Icons.how_to_reg_rounded,
                    gradientColors: GradiantLinearColor.primaryGradiant,
                    onTap: () {
                      Get.to(
                        () => const AbsenceScreen(),
                        transition: Transition.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 400),
                      );
                    },
                    index: 0,
                  ),

                  _buildFeatureCard(
                    title: 'الافتقاد والمتابعة',
                    subtitle: 'متابعة الطلاب المتغيبين والتواصل معهم',
                    tag: 'افتقاد',
                    icon: Icons.person_search_rounded,
                    gradientColors: GradiantLinearColor.emeraldGradient,
                    onTap: () {
                      Get.to(
                        () => const MissingScreen(),
                        transition: Transition.leftToRightWithFade,
                        duration: const Duration(milliseconds: 400),
                      );
                    },
                    index: 1,
                  ),

                  if (CacheHelper.getDataString(key: 'role') == 'Admin')
                    _buildFeatureCard(
                      title: 'افتقاد الأمين',
                      subtitle: 'متابعة تقارير افتقاد كافة الفصول',
                      tag: 'إدارة',
                      icon: Icons.admin_panel_settings_rounded,
                      gradientColors: GradiantLinearColor.amberGradient,
                      onTap: () {
                        Get.to(
                          () => const MissingClassesScreen(),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 400),
                        );
                      },
                      index: 2,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
    Color backgroundColor,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ColorManager.colorXXGrey,
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
    return '${parts[0]} ${parts[1]}';
  } else {
    return fullName;
  }
}