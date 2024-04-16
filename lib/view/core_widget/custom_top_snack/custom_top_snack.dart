// import 'package:flutter/material.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
//
// import '../../../core/color_manager/color_manager.dart';
//
// enum SnackBarType { error, success, info }
//
// class CustomTopSnackBar extends StatelessWidget {
//   final String? message;
//   final SnackBarType? snackBarType;
//
//   const CustomTopSnackBar({
//     super.key,
//     required this.message,
//     required this.snackBarType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     switch (snackBarType) {
//       case SnackBarType.error:
//         return CustomSnackBar.error(
//           maxLines: 10,
//           backgroundColor: Colors.red,
//           message: message!,
//         );
//       case SnackBarType.success:
//         return CustomSnackBar.success(
//           maxLines: 10,
//           backgroundColor: ColorManager.colorPrimary,
//           message: message!,
//         );
//       case SnackBarType.info:
//         return CustomSnackBar.info(
//           backgroundColor: ColorManager.colorGold,
//           message: message!,
//         );
//       default:
//         return CustomSnackBar.success(
//           maxLines: 10,
//           backgroundColor: ColorManager.colorPrimary,
//           message: message!,
//         );
//     }
//   }
// }
