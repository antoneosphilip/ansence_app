import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/assets_manager/assets_manager.dart';
import '../../../../core/route_manager/page_name.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  bool _isLogoCentered = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    navigateToLogin();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLogoCentered = true;
    });
  }

  Future<void> navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Get.offAllNamed(PageName.homeLayout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            top: _isLogoCentered ? 250.h : 30.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Image.asset(
                  AssetsImage.logo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
