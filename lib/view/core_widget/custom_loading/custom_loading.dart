import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 150.0.h),
      child: Center(
        child: Lottie.asset('assets/animation/loading.json',width: 100.w,height: 100.h),
      ),
    );
  }
}
