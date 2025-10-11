import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../../utility/database/local/cache_helper.dart';
import '../../../../view_model/block/absence_cubit/absence_cubit.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with TickerProviderStateMixin {
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
    )
      ..repeat(reverse: true);

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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    // إيقاف الـ animations قبل الـ dispose
    _pulseController.stop();
    _animationController.stop();

    // التخلص من الـ controllers
    _animationController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.colorPrimary.withOpacity(0.1),
                          ColorManager.colorPrimary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      color: ColorManager.colorPrimary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.colorPrimary,
                      ColorManager.colorPrimary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.colorPrimary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 18.sp,
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

  Widget _buildLogoutButton({required int index}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: 'تسجيل الخروج',
                  titleStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[900],
                  ),
                  middleText: 'هل أنت متأكد من تسجيل الخروج؟',
                  middleTextStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[700],
                  ),
                  backgroundColor: Colors.white,
                  radius: 20,
                  textCancel: 'إلغاء',
                  textConfirm: 'تسجيل الخروج',
                  cancelTextColor: Colors.grey[700],
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    // إيقاف الـ animations قبل الخروج
                    if (mounted) {
                      _pulseController.stop();
                      _animationController.stop();
                    }

                    CacheHelper.clearData();
                    Get.offAllNamed('/login');
                    showFlutterToast(
                        message: "تم تسجيل الخروج بنجاح",
                        state: ToastState.SUCCESS
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade400,
                      Colors.red.shade600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 18.sp,
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
                SizedBox(height: 30.h,),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                ColorManager.colorPrimary,
                                ColorManager.colorPrimary.withOpacity(
                                    0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              // BoxShadow(
                              //   color: ColorManager.colorPrimary
                              //       .withOpacity(0.3),
                              //   blurRadius: 20,
                              //   offset: Offset(0, 10),
                              // ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            size: 50.sp,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15.h),

                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(
                          colors: [
                            ColorManager.colorPrimary,
                            ColorManager.colorPrimary.withOpacity(0.7),
                          ],
                        ).createShader(bounds),
                    child: Text(
                      CacheHelper.getDataString(key: 'name') ??
                          'المستخدم',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
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
                      color: ColorManager.colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 14.sp,
                          color: ColorManager.colorPrimary,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'حساب نشط',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ColorManager.colorPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Section Title

                  SizedBox(height: 20.h),

                  // User Info Cards
                  _buildInfoCard(
                    title: 'الاسم',
                    value: CacheHelper.getDataString(key: 'name') ??
                        'غير متوفر',
                    icon: Icons.person_outline,
                    index: 0,
                  ),
                  _buildInfoCard(
                    title: 'البريد الإلكتروني',
                    value: CacheHelper.getDataString(key: 'email') ??
                        'غير متوفر',
                    icon: Icons.email_outlined,
                    index: 1,
                  ),
                  _buildInfoCard(
                    title: 'رقم الهاتف',
                    value: CacheHelper.getDataString(key: 'phone') ??
                        'غير متوفر',
                    icon: Icons.phone_outlined,
                    index: 2,
                  ),

                  SizedBox(height: 20.h),


                  // Action Buttons
                  _buildActionButton(
                    title: 'تحميل البيانات',
                    icon: Icons.cloud_download_outlined,
                    onTap: () async {
                      // إيقاف الـ pulse animation أثناء التحميل
                      if (mounted) {
                        _pulseController.stop();
                      }

                      // تحميل البيانات
                      await AbsenceCubit.get(context).getAllAbsence();

                      if (mounted) {
                        _pulseController.repeat(reverse: true);
                      }
                    },
                    index: 0,
                  ),

                  SizedBox(height: 10.h),

                  // Logout Button
                  _buildLogoutButton(index: 1),

                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}