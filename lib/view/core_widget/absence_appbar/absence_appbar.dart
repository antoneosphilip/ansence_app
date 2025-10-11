import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';

import '../../../core/color_manager/color_manager.dart';

class AnimatedAppBar extends StatefulWidget {
  final String text;
  final IconData icon;

  const AnimatedAppBar({
    super.key,
    required this.text,
    this.icon = Icons.apps,
  });

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24.r),
          bottomLeft: Radius.circular(24.r),
        ),
        gradient: LinearGradient(
          colors: [
            ColorManager.colorPrimary,
            ColorManager.colorPrimary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          // BoxShadow(
          //   color: ColorManager.colorPrimary.withOpacity(0.3),
          //   blurRadius: 15,
          //   offset: Offset(0, 8),
          // ),
        ],
      ),
      child: Stack(
        children: [
          // Back Button
          Positioned(
            right: 10.w,
            top: 40.h,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
          // Title with Pulse Animation
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Icon(
                        widget.icon,
                        color: Colors.white.withOpacity(0.9),
                        size: 28.sp,
                      ),
                    );
                  },
                ),
                SizedBox(width: 10.w),
                Text(
                  widget.text,
                  style: TextStyleManager.textStyle20Bold.copyWith(
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}