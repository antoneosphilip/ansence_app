import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:summer_school_app/view/screens/sign_up/sign_up_screen/sign_up_screen.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_cubit.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_states.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../view_model/repo/auth_repo/auth.dart';

class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(sl.get<AuthRepo>()),
      child: LoginPage(),
    );
  }
}

// Login Page
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Container(
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
          prefixIcon: Icon(prefixIcon,
            color: ColorManager.colorPrimary,
            size: context.w * 0.06,
          ),
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: context.w * 0.04,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorManager.colorPrimary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorWhite,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم تسجيل الدخول بنجاح!'),
                            backgroundColor: ColorManager.colorPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                        // يمكن إضافة Navigation هنا
                        // Navigator.pushReplacementNamed(context, '/home');
                      } else if (state is LoginErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final cubit = AuthCubit.get(context);

                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header Section
                            Container(
                              padding: EdgeInsets.only(bottom: context.h * 0.04),
                              child: Column(
                                children: [
                                  // Logo Container
                                  Container(
                                    width: context.w * 0.25,
                                    height: context.w * 0.25,
                                    constraints: BoxConstraints(
                                      maxWidth: 100,
                                      maxHeight: 100,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorManager.colorPrimary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorManager.colorPrimary.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.school,
                                      size: context.w * 0.12 > 50 ? 50 : context.w * 0.12,
                                      color: ColorManager.colorPrimary,
                                    ),
                                  ),
                                  SizedBox(height: context.h * 0.025),

                                  // Welcome Text
                                  Text(
                                    'أهلاً بك',
                                    style: TextStyle(
                                      fontSize: context.w * 0.08 > 32 ? 32 : context.w * 0.08,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.colorPrimary,
                                    ),
                                  ),
                                  SizedBox(height:3.h),
                                  Text(
                                    'سجل دخولك',
                                    style: TextStyle(
                                      fontSize: context.w * 0.04,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height:3.h),
                                  Text(
                                    'في مدرسة السمائيين',
                                    style: TextStyle(
                                      fontSize: context.w * 0.035,
                                      color: ColorManager.colorPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            // Form Fields
                            _buildTextField(
                              controller: _phoneController,
                              labelText: 'رقم الهاتف',
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
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

                            _buildTextField(
                              controller: _passwordController,
                              labelText: 'كلمة المرور',
                              prefixIcon: Icons.lock,
                              obscureText: !_isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال كلمة المرور';
                                }
                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  // Handle forgot password
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ميزة استعادة كلمة المرور قريباً'),
                                      backgroundColor: ColorManager.colorPrimary,
                                    ),
                                  );
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

                            SizedBox(height: context.h * 0.02),

                            // Login Button
                            Container(
                              width: context.w,
                              height: context.h * 0.07,
                              constraints: BoxConstraints(
                                minHeight: 52.w,
                                maxHeight: 65.h,
                              ),
                              child: ElevatedButton(
                                onPressed: state is LoginLoadingState
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.login(
                                      phone: _phoneController.text.trim(),
                                      password: _passwordController.text,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.colorPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  shadowColor: ColorManager.colorPrimary.withOpacity(0.3),
                                ),
                                child: state is LoginLoadingState
                                    ? SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: const CircularProgressIndicator(
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

                            // Sign Up Link
                            TextButton(
                              onPressed: () {
                                Get.to(SignUpPageWrapper(authCubit: AuthCubit.get(context)));
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

