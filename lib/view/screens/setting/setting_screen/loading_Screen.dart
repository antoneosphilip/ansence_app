import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/slides/v1.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CustomLoading()),
    );
  }
}
