import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../model/auth_response/class_data.dart';
import '../../../../view_model/block/login_cubit/login_cubit.dart';
import '../../../../view_model/block/login_cubit/login_states.dart';

// Extension للـ responsive design
extension Responsive on BuildContext {
  double get w => MediaQuery.of(this).size.width;
  double get h => MediaQuery.of(this).size.height;
}

class SignUpPageWrapper extends StatelessWidget {
  final AuthCubit authCubit;

  const SignUpPageWrapper({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
      child: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
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
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: context.w,
              margin: EdgeInsets.only(bottom: context.h * 0.02),
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
                    fontSize: context.w * 0.035,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: ColorManager.colorPrimary, width: 2.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: ColorManager.colorWhite,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.w * 0.04,
                    vertical: context.h * 0.02,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClassSection(AuthCubit cubit) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: context.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الفصول الدراسية',
                        style: TextStyle(
                          fontSize: context.w * 0.045,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.colorPrimary,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => cubit.addClass(),
                        icon: Icon(Icons.add, size: context.w * 0.045),
                        label: Text(
                          'إضافة فصل',
                          style: TextStyle(fontSize: context.w * 0.035),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.colorPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w * 0.04,
                            vertical: context.h * 0.01,
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.h * 0.02),

                // عرض رسالة خطأ إذا لم يتم إضافة فصول
                if (cubit.classes.isEmpty)
                  Container(
                    width: context.w,
                    padding: EdgeInsets.all(context.w * 0.04),
                    margin: EdgeInsets.only(bottom: context.h * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red[600], size: context.w * 0.05),
                        SizedBox(width: context.w * 0.02),
                        Expanded(
                          child: Text(
                            'يجب إضافة فصل واحد على الأقل مع ملء جميع البيانات المطلوبة',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: context.w * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ...cubit.classes.asMap().entries.map((entry) {
                  int index = entry.key;
                  ClassData classData = entry.value;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: context.w,
                    margin: EdgeInsets.only(bottom: context.h * 0.02),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(context.w * 0.04),
                        child: Column(
                          children: [
                            Container(
                              width: context.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الفصل ${index + 1}',
                                    style: TextStyle(
                                      fontSize: context.w * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.colorPrimary,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => cubit.removeClass(index),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[400],
                                      size: context.w * 0.06,
                                    ),
                                    tooltip: 'حذف الفصل',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.h * 0.015),

                            if (classData.classNumber == null || classData.subject == null)
                              Container(
                                width: context.w,
                                padding: EdgeInsets.all(context.w * 0.03),
                                margin: EdgeInsets.only(bottom: context.h * 0.015),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  border: Border.all(color: Colors.orange[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.orange[600],
                                      size: context.w * 0.045,
                                    ),
                                    SizedBox(width: context.w * 0.02),
                                    Expanded(
                                      child: Text(
                                        'يجب ملء جميع بيانات هذا الفصل',
                                        style: TextStyle(
                                          color: Colors.orange[600],
                                          fontSize: context.w * 0.03,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            Container(
                              width: context.w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: classData.classNumber,
                                      decoration: InputDecoration(
                                        labelText: 'رقم الفصل *',
                                        labelStyle: TextStyle(
                                          fontSize: context.w * 0.035,
                                          color: classData.classNumber == null
                                              ? Colors.red[600]
                                              : Colors.grey[600],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: classData.classNumber == null
                                                ? Colors.red
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: classData.classNumber == null
                                                ? Colors.red
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: context.w * 0.03,
                                          vertical: context.h * 0.01,
                                        ),
                                      ),
                                      style: TextStyle(fontSize: context.w * 0.035),
                                      items: List.generate(30, (index) => index + 1)
                                          .map((number) => DropdownMenuItem(
                                        value: number,
                                        child: Text(
                                          'الفصل $number',
                                          style: TextStyle(
                                              fontSize: context.w * 0.035, color: Colors.black),
                                        ),
                                      ))
                                          .toList(),
                                      onChanged: (value) {
                                        cubit.updateClassNumber(index, value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: context.w * 0.03),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: classData.subject,
                                      decoration: InputDecoration(
                                        labelText: 'المادة *',
                                        labelStyle: TextStyle(
                                          fontSize: context.w * 0.035,
                                          color: classData.subject == null
                                              ? Colors.red[600]
                                              : Colors.grey[600],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: classData.subject == null
                                                ? Colors.red
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: classData.subject == null
                                                ? Colors.red
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: context.w * 0.03,
                                          vertical: context.h * 0.01,
                                        ),
                                      ),
                                      style: TextStyle(fontSize: context.w * 0.035, color: ColorManager.colorWhite),
                                      items: ['ألحان', 'قبطي', 'طقس']
                                          .map((subject) => DropdownMenuItem(
                                        value: subject,
                                        child: Text(
                                          subject,
                                          style: TextStyle(
                                              fontSize: context.w * 0.035, color: Colors.black),
                                        ),
                                      ))
                                          .toList(),
                                      onChanged: classData.classNumber != null
                                          ? (value) {
                                        cubit.updateClassSubject(index, value);
                                      }
                                          : null,
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
                }).toList(),
              ],
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
                  width: context.w > 600 ? context.w * 0.7 : context.w,
                  constraints: BoxConstraints(maxWidth: 600),
                  child: BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is SignUpSuccessState) {
                     showFlutterToast(message: "تم إنشاء الحساب بنجاح!", state: ToastState.SUCCESS);
                      } else if (state is SignUpErrorState) {
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
                              key: cubit.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Header with Animations
                                  Container(
                                    padding: EdgeInsets.only(bottom: context.h * 0.03),
                                    child: Column(
                                      children: [
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
                                                        width: context.w * 0.2,
                                                        height: context.w * 0.2,
                                                        constraints: BoxConstraints(
                                                          maxWidth: 80.w,
                                                          maxHeight: 80.h,
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
                                                          size: context.w * 0.1 > 40 ? 40 : context.w * 0.1,
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
                                        SizedBox(height: context.h * 0.02),
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
                                                        'إنشاء حساب جديد',
                                                        style: TextStyle(
                                                          fontSize: context.w * 0.07 > 28
                                                              ? 28
                                                              : context.w * 0.07,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3.h),
                                                    Text(
                                                      'مدرسة السمائيين',
                                                      style: TextStyle(
                                                        fontSize: context.w * 0.04,
                                                        color: Colors.grey[600],
                                                      ),
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

                                  // Form Fields with Staggered Animations
                                  _buildAnimatedTextField(
                                    controller: cubit.nameController,
                                    labelText: 'الاسم الكامل',
                                    prefixIcon: Icons.person,
                                    index: 0,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال الاسم';
                                      }
                                      return null;
                                    },
                                  ),

                                  _buildAnimatedTextField(
                                    controller: cubit.phoneController,
                                    labelText: 'رقم الهاتف',
                                    prefixIcon: Icons.phone,
                                    keyboardType: TextInputType.phone,
                                    index: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال رقم الهاتف';
                                      }
                                      return null;
                                    },
                                  ),

                                  _buildAnimatedTextField(
                                    controller: cubit.emailController,
                                    labelText: 'البريد الإلكتروني',
                                    prefixIcon: Icons.email,
                                    keyboardType: TextInputType.emailAddress,
                                    index: 2,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال البريد الإلكتروني';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'يرجى إدخال بريد إلكتروني صحيح';
                                      }
                                      return null;
                                    },
                                  ),

                                  _buildAnimatedTextField(
                                    controller: cubit.passwordController,
                                    labelText: 'كلمة المرور',
                                    prefixIcon: Icons.lock,
                                    obscureText: true,
                                    index: 3,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى إدخال كلمة المرور';
                                      }
                                      if (value.length < 6) {
                                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                      }
                                      return null;
                                    },
                                  ),

                                  _buildAnimatedTextField(
                                    controller: cubit.confirmPasswordController,
                                    labelText: 'تأكيد كلمة المرور',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    index: 4,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى تأكيد كلمة المرور';
                                      }
                                      if (value != cubit.passwordController.text) {
                                        return 'كلمة المرور غير متطابقة';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: context.h * 0.03),

                                  // Classes Section
                                  _buildClassSection(cubit),

                                  SizedBox(height: context.h * 0.04),

                                  // Sign Up Button with Animation
                                  TweenAnimationBuilder<double>(
                                    duration: Duration(milliseconds: 1500),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.elasticOut,
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Container(
                                          width: context.w,
                                          height: context.h * 0.07,
                                          constraints: BoxConstraints(
                                            minHeight: 50.h,
                                            maxHeight: 60.w,
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
                                            onPressed: state is SignUpLoadingState
                                                ? null
                                                : () {
                                              if (cubit.formKey.currentState!.validate()) {
                                                cubit.signUp();
                                              } else {
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
                                            child: state is SignUpLoadingState
                                                ? SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                                : Text(
                                              'إنشاء الحساب',
                                              style: TextStyle(
                                                fontSize: context.w * 0.045.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(height: context.h * 0.02),

                                  // Login Link
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'لديك حساب بالفعل؟ ',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: context.w * 0.035,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'تسجيل الدخول',
                                            style: TextStyle(
                                              color: ColorManager.colorPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: context.w * 0.035,
                                            ),
                                          ),
                                        ],
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
    );
  }
}