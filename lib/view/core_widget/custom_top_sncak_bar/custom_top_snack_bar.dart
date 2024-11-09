
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSnackBarWidget(context,String message)=> showTopSnackBar(
  Overlay.of(context),
  animationDuration: const Duration(milliseconds: 400),
  displayDuration: const Duration(seconds: 3),
  CustomSnackBar.success(
      message: message,
    backgroundColor: Colors.white,
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.black,),
  ),
);

