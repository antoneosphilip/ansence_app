// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/color_manager/color_manager.dart';
// import '../../../core/style_font_manager/style_manager.dart';
// import '../elevated_button/elevated_button_custom.dart';
//
// class CustomBottomSheetButton extends StatelessWidget {
//   const CustomBottomSheetButton(
//       {super.key, required this.text, required this.onPressed});
//
//   final String text;
//   final Function onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Padding(
//         padding: EdgeInsets.all(15.sp),
//         child: ElevatedButtonCustom(
//           onPressed: () {
//             onPressed!();
//           },
//           colors: ColorManager.colorPrimary,
//           widget: Text(
//             text!,
//             style: TextStyleManager.textStyle14w500.copyWith(fontSize: 18.sp,color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
