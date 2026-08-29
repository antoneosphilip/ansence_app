import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view/screens/sign_up/sign_up_screen/sign_up_screen.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_cubit.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_states.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../forget_password/forget_password_screen/forget_password_screen.dart';
import '../../home_layout/home_layout.dart';

class LoginPageWrapper extends StatelessWidget {
  const LoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late AnimationController _floatingAnimationController;
  late AnimationController _shakeAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(
        parent: _floatingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _shakeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingAnimationController.dispose();
    _shakeAnimationController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeAnimationController.forward(from: 0);
  }

  double _shake(double value) {
    return sin(value * pi * 4) * 8;
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: ColorManager.colorLightBlack,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ColorManager.colorDarkBlue,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              color: ColorManager.colorPrimary,
              size: 22,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorScaffold,
      body: Stack(
        children: [
          // Ambient Background Glows
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.colorPrimary.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.colorCyan.withOpacity(0.12),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: BlocConsumer<AuthCubit, AuthStates>(
                        listener: (context, state) {
                          if (state is LoginSuccessState) {
                            showFlutterToast(
                                message: 'تم تسجيل الدخول بنجاح!',
                                state: ToastState.SUCCESS);
                            AbsenceCubit.get(context).getAllAbsenceFromStart();
                            Get.offAll(() => const HomeLayoutScreen());
                          } else if (state is LoginErrorState) {
                            showFlutterToast(
                                message: state.error, state: ToastState.ERROR);
                          }
                        },
                        builder: (context, state) {
                          final cubit = AuthCubit.get(context);

                          return AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset:
                                    Offset(_shake(_shakeAnimation.value), 0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Floating Header Section
                                      AnimatedBuilder(
                                        animation: _floatingAnimation,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                                0, _floatingAnimation.value),
                                            child: Center(
                                              child: Container(
                                                width: 88,
                                                height: 88,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: GradiantLinearColor
                                                        .primaryGradiant,
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                  boxShadow:
                                                      ColorManager.glowShadow(
                                                          ColorManager
                                                              .colorPrimary),
                                                ),
                                                child: const Icon(
                                                  Icons.school_rounded,
                                                  size: 46,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Welcome Titles
                                      const Text(
                                        'مرحباً بك مجدداً 👋',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.colorDarkBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'سجل دخولك لمتابعة الحضور والغياب',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ColorManager.colorXXGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 32),

                                      // Form Card
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: ColorManager.colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          boxShadow: ColorManager.cardShadow,
                                          border: Border.all(
                                            color: ColorManager.colorGrey4,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Phone Field
                                            _buildModernTextField(
                                              controller:
                                                  cubit.phoneController,
                                              labelText: 'رقم الهاتف',
                                              hintText: '01xxxxxxxxx',
                                              prefixIcon: Icons.phone_android_rounded,
                                              keyboardType:
                                                  TextInputType.phone,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'يرجى إدخال رقم الهاتف';
                                                }
                                                if (value.length < 11) {
                                                  return 'رقم الهاتف غير صحيح';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),

                                            // Password Field
                                            _buildModernTextField(
                                              controller:
                                                  cubit.passwordController,
                                              labelText: 'كلمة المرور',
                                              hintText: '••••••••',
                                              prefixIcon: Icons.lock_outline_rounded,
                                              obscureText: !_isPasswordVisible,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'يرجى إدخال كلمة المرور';
                                                }
                                                return null;
                                              },
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons.visibility_rounded
                                                      : Icons.visibility_off_rounded,
                                                  color:
                                                      ColorManager.colorXXGrey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 12),

                                            // Forgot Password Link
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      EnterEmailScreen());
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: const Text(
                                                  'نسيت كلمة المرور؟',
                                                  style: TextStyle(
                                                    color: ColorManager
                                                        .colorPrimary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),

                                            // Login Button
                                            Container(
                                              height: 52,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: GradiantLinearColor
                                                      .primaryGradiant,
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow:
                                                    ColorManager.glowShadow(
                                                        ColorManager
                                                            .colorPrimary),
                                              ),
                                              child: ElevatedButton(
                                                onPressed: state
                                                        is LoginLoadingState
                                                    ? null
                                                    : () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          cubit.login();
                                                        } else {
                                                          _triggerShake();
                                                        }
                                                      },
                                                style:
                                                    ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                ),
                                                child: state
                                                        is LoginLoadingState
                                                    ? const SizedBox(
                                                        width: 22,
                                                        height: 22,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2.5,
                                                        ),
                                                      )
                                                    : const Text(
                                                        'تسجيل الدخول',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 28),

                                      // Sign Up Prompt
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                              () =>
                                                  const SignUpPageWrapper(),
                                              transition:
                                                  Transition.rightToLeftWithFade,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                            );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'ليس لديك حساب؟ ',
                                                style: TextStyle(
                                                  color:
                                                      ColorManager.colorXXGrey,
                                                  fontSize: 14,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'إنشاء حساب جديد',
                                                    style: TextStyle(
                                                      color: ColorManager
                                                          .colorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}