import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 100.h),
      child: Center(
        child: Lottie.asset('assets/animation/error2.json',width: 220.w,height: 220.h,),
      ),
    );
  }
}
