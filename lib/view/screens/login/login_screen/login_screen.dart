import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition; // ✅ اخفينا Transition بتاع bloc
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart'; // ✅ هنا هنستعمل Transition بتاع GetX
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view/screens/home/home_screen/home_screen.dart';
import 'package:summer_school_app/view/screens/sign_up/sign_up_screen/sign_up_screen.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_cubit.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_states.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../view_model/repo/auth_repo/auth.dart';
import '../../forget_password/forget_password_screen/forget_password_screen.dart';
import '../../home_layout/home_layout.dart';

class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late AnimationController _floatingAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _shakeAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation للظهور
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Animation للطفو (Floating)
    _floatingAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _floatingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation للنبض (Pulse)
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Animation للهزة (Shake)
    _shakeAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _shakeAnimationController,
        curve: Curves.elasticIn,
      ),
    );

    // بدء الأنيميشنات
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingAnimationController.dispose();
    _pulseAnimationController.dispose();
    _shakeAnimationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة الهزة
  void _triggerShake() {
    _shakeAnimationController.forward(from: 0);
  }

  // دالة حساب الهزة
  double _shake(double value) {
    return sin(value * pi * 4) * 10;
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: context.w,
              margin: EdgeInsets.only(bottom: context.h * 0.025),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                validator: validator,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: context.w * 0.04),
                decoration: InputDecoration(
                  labelText: labelText,
                  prefixIcon: Icon(
                    prefixIcon,
                    color: ColorManager.colorPrimary,
                    size: context.w * 0.06,
                  ),
                  suffixIcon: suffixIcon,
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: context.w * 0.04,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ColorManager.colorPrimary,
                      width: 2.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red[400]!, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red[400]!, width: 2),
                  ),
                  filled: true,
                  fillColor: ColorManager.colorWhite,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.w * 0.04,
                    vertical: context.h * 0.022,
                  ),
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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.w > 600 ? context.w * 0.05 : context.w * 0.05),
                child: Container(
                  width: context.w > 600 ? context.w * 0.6 : context.w,
                  constraints: BoxConstraints(maxWidth: 500),
                  child: BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is LoginSuccessState) {
                      showFlutterToast(message: 'تم تسجيل الدخول بنجاح!', state: ToastState.SUCCESS);
                      Get.to(
                            () => HomeLayoutScreen(),
                      );
                      } else if (state is LoginErrorState) {
                        showFlutterToast(message: state.error, state: ToastState.ERROR);
                      }
                    },
                    builder: (context, state) {
                      final cubit = AuthCubit.get(context);

                      return AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shake(_shakeAnimation.value), 0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header Section with Floating Animation
                                  Container(
                                    padding: EdgeInsets.only(bottom: context.h * 0.04),
                                    child: Column(
                                      children: [
                                        // Logo Container with Animations
                                        AnimatedBuilder(
                                          animation: _floatingAnimation,
                                          builder: (context, child) {
                                            return Transform.translate(
                                              offset: Offset(0, _floatingAnimation.value),
                                              child: ScaleTransition(
                                                scale: _scaleAnimation,
                                                child: AnimatedBuilder(
                                                  animation: _pulseAnimation,
                                                  builder: (context, child) {
                                                    return Transform.scale(
                                                      scale: _pulseAnimation.value,
                                                      child: Container(
                                                        width: context.w * 0.25,
                                                        height: context.w * 0.25,
                                                        constraints: const BoxConstraints(
                                                          maxWidth: 100,
                                                          maxHeight: 100,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              ColorManager.colorPrimary,
                                                              ColorManager.colorPrimary.withOpacity(0.8),
                                                            ],
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                          ),
                                                          shape: BoxShape.circle,

                                                        ),
                                                        child: Icon(
                                                          Icons.school,
                                                          size: context.w * 0.12 > 50 ? 50 : context.w * 0.12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: context.h * 0.025),

                                        // Welcome Text with Animation
                                        TweenAnimationBuilder<double>(
                                          duration: Duration(milliseconds: 800),
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          curve: Curves.easeOut,
                                          builder: (context, value, child) {
                                            return Opacity(
                                              opacity: value,
                                              child: Transform.translate(
                                                offset: Offset(0, 30 * (1 - value)),
                                                child: Column(
                                                  children: [
                                                    ShaderMask(
                                                      shaderCallback: (bounds) => LinearGradient(
                                                        colors: [
                                                          ColorManager.colorPrimary,
                                                          ColorManager.colorPrimary.withOpacity(0.7),
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Text(
                                                        'أهلاً بك',
                                                        style: TextStyle(
                                                          fontSize: context.w * 0.08 > 32 ? 32 : context.w * 0.08,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3.h),
                                                    Text(
                                                      'سجل دخولك',
                                                      style: TextStyle(
                                                        fontSize: context.w * 0.04,
                                                        color: Colors.grey[600],
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(height: 3.h),
                                                    Text(
                                                      'في مدرسة السمائيين',
                                                      style: TextStyle(
                                                        fontSize: context.w * 0.035,
                                                        color: ColorManager.colorPrimary,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Form Fields with Staggered Animation
                                  _buildAnimatedTextField(
                                    controller: cubit.phoneController,
                                    labelText: 'رقم الهاتف',
                                    prefixIcon: Icons.phone,
                                    keyboardType: TextInputType.phone,
                                    index: 0,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال رقم الهاتف';
                                      }
                                      if (value.length < 11) {
                                        return 'رقم الهاتف غير صحيح';
                                      }
                                      return null;
                                    },
                                  ),

                                  _buildAnimatedTextField(
                                    controller: cubit.passwordController,
                                    labelText: 'كلمة المرور',
                                    prefixIcon: Icons.lock,
                                    obscureText: !_isPasswordVisible,
                                    index: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال كلمة المرور';
                                      }
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: ColorManager.colorPrimary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),

                                  // Forgot Password Link
                                  TweenAnimationBuilder<double>(
                                    duration: Duration(milliseconds: 1000),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOut,
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextButton(
                                            onPressed: () {
                                               Get.to( EnterEmailScreen());
                                            },
                                            child: Text(
                                              'نسيت كلمة المرور؟',
                                              style: TextStyle(
                                                color: ColorManager.colorPrimary,
                                                fontSize: context.w * 0.035,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(height: context.h * 0.02),

                                  // Animated Login Button
                                  TweenAnimationBuilder<double>(
                                    duration: Duration(milliseconds: 1200),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.elasticOut,
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Container(
                                          width: context.w,
                                          height: context.h * 0.07,
                                          constraints: BoxConstraints(
                                            minHeight: 52.w,
                                            maxHeight: 65.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                              colors: [
                                                ColorManager.colorPrimary,
                                                ColorManager.colorPrimary.withOpacity(0.8),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorManager.colorPrimary.withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: state is LoginLoadingState
                                                ? null
                                                : () {
                                              // Get.to(
                                              //       () => HomeScreen(),
                                              // );
                                              if (_formKey.currentState!.validate()) {
                                                cubit.login();
                                              } else {
                                                // تشغيل أنيميشن الهزة
                                                _triggerShake();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              foregroundColor: Colors.white,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: state is LoginLoadingState
                                                ? SizedBox(
                                              width: 24.w,
                                              height: 24.h,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                                : Text(
                                              'تسجيل الدخول',
                                              style: TextStyle(
                                                fontSize: context.w * 0.045,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(height: context.h * 0.025),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey[300])),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: context.w * 0.04),
                                        child: Text(
                                          'أو',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: context.w * 0.035,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey[300])),
                                    ],
                                  ),

                                  SizedBox(height: context.h * 0.025),

                                  // Sign Up Link مع أنيميشن انتقال
                                  TextButton(
                                    onPressed: () {
                                      Get.to(
                                            () => SignUpPageWrapper(),
                                        transition: Transition.rightToLeftWithFade,
                                        duration: Duration(milliseconds: 1000),
                                      );
                                    },
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'ليس لديك حساب؟ ',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: context.w * 0.04,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'إنشاء حساب جديد',
                                            style: TextStyle(
                                              color: ColorManager.colorPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: context.w * 0.04,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: context.h * 0.02),
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
    );
  }
}