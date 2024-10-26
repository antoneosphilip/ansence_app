import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/color_manager/color_manager.dart';

class CallButton extends StatelessWidget {
  final String text;
  const CallButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {

    return  ElevatedButton.icon(
      onPressed: () {
        // Add your call function here
      },
      icon: const Icon(Icons.call, color: Colors.white),
      label:  Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.colorPrimary, // Background color
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r), // Rounded corners
        ),
      ),
    );
  }
}
