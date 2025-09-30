import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

// SignUp Page
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    AuthCubit.get(context).animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    AuthCubit.get(context).fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: AuthCubit.get(context).animationController, curve: Curves.easeInOut),
    );

    AuthCubit.get(context).slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: AuthCubit.get(context).animationController, curve: Curves.easeOut));

    AuthCubit.get(context).animationController.forward();
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
          prefixIcon: Icon(prefixIcon,
            color: ColorManager.colorPrimary,
            size: context.w * 0.06,
          ),
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: context.w * 0.035,
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
          filled: true,
          fillColor: ColorManager.colorWhite,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.w * 0.04,
            vertical: context.h * 0.02,
          ),
        ),
      ),
    );
  }

  Widget _buildClassSection(AuthCubit cubit) {
    return Column(
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w * 0.04,
                    vertical: context.h * 0.01,
                  ),
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
              borderRadius: BorderRadius.circular(8),
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
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              color: ColorManager.colorPrimary,
                              size: context.w * 0.06,
                            ),
                            tooltip: 'حذف الفصل',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.h * 0.015),

                    // عرض رسالة تحذير إذا لم يتم ملء بيانات الفصل
                    if (classData.classNumber == null || classData.subject == null)
                      Container(
                        width: context.w,
                        padding: EdgeInsets.all(context.w * 0.03),
                        margin: EdgeInsets.only(bottom: context.h * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          border: Border.all(color: Colors.orange[300]!),
                          borderRadius: BorderRadius.circular(6),
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
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: classData.classNumber == null
                                        ? Colors.red
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                                  style: TextStyle(fontSize: context.w * 0.035,color: Colors.black),
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
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: classData.subject == null
                                        ? Colors.red
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                              style: TextStyle(fontSize: context.w * 0.035,color: ColorManager.colorWhite),
                              items: ['ألحان', 'قبطي', 'طقس']
                                  .map((subject) => DropdownMenuItem(
                                value: subject,
                                child: Text(
                                  subject,
                                  style: TextStyle(fontSize: context.w * 0.035,color: Colors.black),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorWhite,
      body: SafeArea(
        child: FadeTransition(
          opacity: AuthCubit.get(context).fadeAnimation,
          child: SlideTransition(
            position: AuthCubit.get(context).slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.w > 600 ? context.w * 0.05 : context.w * 0.05),
                child: Container(
                  width: context.w > 600 ? context.w * 0.7 : context.w,
                  constraints: BoxConstraints(maxWidth: 600),
                  child: BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is SignUpSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إنشاء الحساب بنجاح!'),
                            backgroundColor: ColorManager.colorPrimary,
                          ),
                        );
                      } else if (state is SignUpErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final cubit = AuthCubit.get(context);

                      return Form(
                        key: cubit.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            Container(
                              padding: EdgeInsets.only(bottom: context.h * 0.03),
                              child: Column(
                                children: [
                                  Container(
                                    width: context.w * 0.2,
                                    height: context.w * 0.2,
                                    constraints: BoxConstraints(
                                      maxWidth: 80.w,
                                      maxHeight: 80.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorManager.colorPrimary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.school,
                                      size: context.w * 0.1 > 40 ? 40 : context.w * 0.1,
                                      color: ColorManager.colorPrimary,
                                    ),
                                  ),
                                  SizedBox(height: context.h * 0.02),
                                  Text(
                                    'إنشاء حساب جديد',
                                    style: TextStyle(
                                      fontSize: context.w * 0.07 > 28 ? 28 : context.w * 0.07,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.colorPrimary,
                                    ),
                                  ),
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

                            // Form Fields
                            _buildTextField(
                              controller: AuthCubit.get(context).nameController,
                              labelText: 'الاسم الكامل',
                              prefixIcon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال الاسم';
                                }
                                return null;
                              },
                            ),

                            _buildTextField(
                              controller: AuthCubit.get(context).phoneController,
                              labelText: 'رقم الهاتف',
                              prefixIcon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال رقم الهاتف';
                                }
                                return null;
                              },
                            ),

                            _buildTextField(
                              controller: AuthCubit.get(context).emailController,
                              labelText: 'البريد الإلكتروني',
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
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

                            _buildTextField(
                              controller: AuthCubit.get(context).passwordController,
                              labelText: 'كلمة المرور',
                              prefixIcon: Icons.lock,
                              obscureText: true,
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

                            _buildTextField(
                              controller: AuthCubit.get(context).confirmPasswordController,
                              labelText: 'تأكيد كلمة المرور',
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى تأكيد كلمة المرور';
                                }
                                if (value != AuthCubit.get(context).passwordController.text) {
                                  return 'كلمة المرور غير متطابقة';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: context.h * 0.03),

                            // Classes Section
                            _buildClassSection(cubit),

                            SizedBox(height: context.h * 0.04),

                            // Sign Up Button
                            Container(
                              width: context.w,
                              height: context.h * 0.07,
                              constraints: BoxConstraints(
                                minHeight: 50.h,
                                maxHeight: 60.w,
                              ),
                              child: ElevatedButton(
                                onPressed: state is SignUpLoadingState
                                    ? null
                                    : () {
                                  if (cubit.formKey.currentState!.validate()) {
                                    cubit.signUp(
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
  }}