import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../splash_widget/splash_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashWidget(),
    );
  }
}
