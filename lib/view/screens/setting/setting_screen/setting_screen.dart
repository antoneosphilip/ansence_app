import 'package:flutter/material.dart';
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

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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

  Widget _buildInfoTile({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: ColorManager.softShadow,
        border: Border.all(
          color: ColorManager.colorGrey4,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorManager.colorXXGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.colorDarkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = CacheHelper.getDataString(key: 'name') ?? 'الخادم';
    final String email =
        CacheHelper.getDataString(key: 'email') ?? 'غير متوفر';
    final String phone =
        CacheHelper.getDataString(key: 'phone') ?? 'غير متوفر';
    final String role = CacheHelper.getDataString(key: 'role') ?? 'خادم';

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
                  // Profile Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
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
                      children: [
                        // Profile Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: GradiantLinearColor.primaryGradiant,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: ColorManager.glowShadow(
                                ColorManager.colorPrimary),
                          ),
                          child: Center(
                            child: Text(
                              name.isNotEmpty ? name.substring(0, 1) : 'خ',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.colorDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: ColorManager.colorPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            role == 'Admin' ? 'أمين الخدمة ⭐' : 'خادم نشط ✓',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.colorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // User Info Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'البيانات الشخصية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.colorDarkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildInfoTile(
                    title: 'الاسم الكامل',
                    value: name,
                    icon: Icons.person_rounded,
                    iconColor: ColorManager.colorPrimary,
                  ),
                  _buildInfoTile(
                    title: 'البريد الإلكتروني',
                    value: email,
                    icon: Icons.alternate_email_rounded,
                    iconColor: ColorManager.colorCyan,
                  ),
                  _buildInfoTile(
                    title: 'رقم الهاتف',
                    value: phone,
                    icon: Icons.phone_rounded,
                    iconColor: ColorManager.colorGreen,
                  ),

                  const SizedBox(height: 24),

                  // Actions Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'إدارة البيانات والحساب',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.colorDarkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sync Data Action
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: GradiantLinearColor.primaryGradiant,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: ColorManager.glowShadow(
                          ColorManager.colorPrimary),
                    ),
                    child: InkWell(
                      onTap: () async {
                        showFlutterToast(
                            message: "جاري تحديث البيانات...",
                            state: ToastState.SUCCESS);
                        await AbsenceCubit.get(context).getAllAbsence();
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.cloud_sync_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 14),
                                Text(
                                  'تحديث ومزامنة البيانات',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Logout Action
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColorManager.colorWhite,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: ColorManager.colorRed.withOpacity(0.3),
                        width: 1.2,
                      ),
                      boxShadow: ColorManager.softShadow,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          title: 'تسجيل الخروج',
                          titleStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.colorDarkBlue,
                          ),
                          middleText: 'هل أنت متأكد من تسجيل الخروج من التطبيق؟',
                          middleTextStyle: const TextStyle(
                            fontSize: 14,
                            color: ColorManager.colorXXGrey,
                          ),
                          backgroundColor: ColorManager.colorWhite,
                          radius: 20,
                          textCancel: 'إلغاء',
                          textConfirm: 'تأكيد الخروج',
                          cancelTextColor: ColorManager.colorXXGrey,
                          confirmTextColor: Colors.white,
                          buttonColor: ColorManager.colorRed,
                          onConfirm: () {
                            CacheHelper.clearData();
                            Get.offAllNamed('/login');
                            showFlutterToast(
                              message: "تم تسجيل الخروج بنجاح",
                              state: ToastState.SUCCESS,
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: ColorManager.colorRed,
                                  size: 22,
                                ),
                                SizedBox(width: 14),
                                Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.colorRed,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: ColorManager.colorRed,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
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