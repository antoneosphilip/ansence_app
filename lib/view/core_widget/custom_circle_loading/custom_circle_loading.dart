import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/color_manager/color_manager.dart';

class CustomCircleLoading extends StatelessWidget {
  const CustomCircleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: ColorManager.colorPrimary,));
  }
}
