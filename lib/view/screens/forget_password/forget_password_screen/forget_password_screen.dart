// ============================================
// 1. صفحة إدخال الإيميل
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pinput/pinput.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'dart:async';

import '../../../../view_model/block/login_cubit/login_cubit.dart';
import '../../../../view_model/block/login_cubit/login_states.dart';

class EnterEmailScreen extends StatelessWidget {
  const EnterEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'استعادة كلمة السر',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is SendEmailSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnterOtpScreen(),
                ),
              );
            } else if (state is SendEmailErrorState) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('خطأ'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is SendEmailLoadingState;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:  24.w,
                  vertical: 20.h,
                ),
                child: Form(
                  key: cubit.formKeyEnterEmail,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.email_outlined,
                        size: 100,
                        color: Colors.teal.withOpacity(0.7),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'أدخل بريدك الإلكتروني',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'سنرسل لك كود التحقق على بريدك الإلكتروني',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: cubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          hintText: 'example@email.com',
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.teal, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك أدخل البريد الإلكتروني';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'البريد الإلكتروني غير صحيح';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 100.h,),
                      SizedBox(
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            if (cubit.formKeyEnterEmail.currentState!.validate()) {
                              cubit.sendEmail();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'إرسال الكود',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================
// 2. صفحة إدخال OTP مع Timer
// ============================================

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  Timer? _timer;
  int _remainingSeconds = 120;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = 120;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _resendOtp() {
    AuthCubit.get(context).sendEmail();
    _startTimer();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'التحقق من الكود',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is CheckOtpSuccessState) {
              Get.to(const NewPasswordScreen());
            }

            else if (state is CheckOtpErrorState) {
              showFlutterToast(message: state.error.toString(), state: ToastState.ERROR);
            } else if (state is SendEmailSuccessState) {
              showFlutterToast(message: "تم إعادة إرسال الكود بنجاح", state: ToastState.ERROR);

            } else if (state is SendEmailErrorState) {
              showFlutterToast(message: state.error.toString(), state: ToastState.ERROR);
            }
          },
          builder: (context, state) {
            final isLoading = state is CheckOtpLoadingState;
            final isResending = state is SendEmailLoadingState;

            final defaultPinTheme = PinTheme(
              width: 56,
              height: 60,
              textStyle: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
            );

            final focusedPinTheme = defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 2),
              ),
            );

            final submittedPinTheme = defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal),
              ),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth > 600 ? constraints.maxWidth * 0.2 : 24,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),
                            Icon(
                              Icons.lock_outline,
                              size: 100,
                              color: Colors.teal.withOpacity(0.7),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'أدخل كود التحقق',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'أدخل الكود المرسل إلى\n${AuthCubit.get(context).emailController.text}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 40),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Pinput(
                                controller: AuthCubit.get(context).otpController,
                                length: 6,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                showCursor: true,
                                pinAnimationType: PinAnimationType.fade,
                                onCompleted: (pin) {
                                  if (!isLoading && !isResending) {
                                    AuthCubit.get(context).checkOtp();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Timer & Resend Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!_canResend)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.timer_outlined,
                                          color: Colors.teal,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(_remainingSeconds),
                                          style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_canResend)
                                  TextButton.icon(
                                    onPressed: (isLoading || isResending)
                                        ? null
                                        : _resendOtp,
                                    icon: isResending
                                        ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.teal,
                                      ),
                                    )
                                        : const Icon(Icons.refresh, color: Colors.teal),
                                    label: const Text(
                                      'إعادة إرسال الكود',
                                      style: TextStyle(
                                        color: Colors.teal,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: (isLoading || isResending)
                                    ? null
                                    : () {
                                  if (AuthCubit.get(context).otpController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('من فضلك أدخل الكود'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  AuthCubit.get(context).checkOtp();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'تحقق',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ============================================
// 3. صفحة كلمة السر الجديدة
// ============================================

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'كلمة السر الجديدة',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is ChangePasswordSuccessState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.teal, size: 32),
                      SizedBox(width: 12),
                      Text('نجح'),
                    ],
                  ),
                  content: const Text('تم تغيير كلمة السر بنجاح\nيمكنك الآن تسجيل الدخول'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AuthCubit.get(context).emailController.clear();
                        AuthCubit.get(context).otpController.clear();
                        AuthCubit.get(context).passwordController.clear();
                        AuthCubit.get(context).confirmPasswordController.clear();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ChangePasswordErrorState) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('خطأ'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ChangePasswordLoadingState;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth > 600 ? constraints.maxWidth * 0.2 : 24,
                          vertical: 20,
                        ),
                        child: Form(
                          key: AuthCubit.get(context).formKeyForget,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 40),
                              Icon(
                                Icons.vpn_key_outlined,
                                size: 100,
                                color: Colors.teal.withOpacity(0.7),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'كلمة السر الجديدة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'أدخل كلمة السر الجديدة الخاصة بك',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                controller: AuthCubit.get(context).passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'كلمة السر الجديدة',
                                  hintText: 'أدخل كلمة السر',
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.teal,
                                    ),
                                    onPressed: () {
                                      setState(() => _obscurePassword = !_obscurePassword);
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.teal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'من فضلك أدخل كلمة السر';
                                  }
                                  if (value.length < 6) {
                                    return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: AuthCubit.get(context).confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: 'تأكيد كلمة السر',
                                  hintText: 'أعد إدخال كلمة السر',
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.teal,
                                    ),
                                    onPressed: () {
                                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.teal),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'من فضلك أكد كلمة السر';
                                  }
                                  if (value != AuthCubit.get(context).passwordController.text) {
                                    return 'كلمة السر غير متطابقة';
                                  }
                                  return null;
                                },
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                    if (AuthCubit.get(context).formKeyForget.currentState!.validate()) {
                                      AuthCubit.get(context).changePassword();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : const Text(
                                    'تغيير كلمة السر',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}