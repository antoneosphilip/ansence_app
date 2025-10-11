import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ----------------- Helper -----------------
Widget buildShimmerStatItem() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(height: 8.h),
      Container(
        width: 60.w,
        height: 10.h,
        color: Colors.grey.shade300,
      ),
      SizedBox(height: 4.h),
      Container(
        width: 40.w,
        height: 10.h,
        color: Colors.grey.shade300,
      ),
    ],
  );
}
