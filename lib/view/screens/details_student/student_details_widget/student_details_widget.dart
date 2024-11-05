//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:summer_school_app/core/Custom_Text/custom_text.dart';
// import 'package:summer_school_app/core/color_manager/color_manager.dart';
// import 'package:summer_school_app/core/text_manager/text_manager.dart';
// import 'package:summer_school_app/view/core_widget/text_form_field/text_form_field_custom.dart';
// import 'package:summer_school_app/view/screens/details_student/student_details_widget/student_details_form.dart';
//
// class StudentDetailsWidget extends StatelessWidget {
//   const StudentDetailsWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//       children: [
//         SizedBox(height: 15.h,),
//         Center(
//           child: Column(
//             children: [
//               CircleAvatar(
//                 backgroundColor: ColorManager.colorGrey,
//                 radius: 45.sp,
//                 backgroundImage: const CachedNetworkImageProvider(
//                     'https://th.bing.com/th/id/OIP.j8yd8dJ5215WbgQ0NsLzuAHaNK?rs=1&pid=ImgDetMain',
//                 ),
//               ),
//               SizedBox(height: 10.h,),
//               TextWidget(text: TextManager.changePhoto, textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold,color: ColorManager.colorPrimary)!)
//             ],
//           ),
//         ),
//         SizedBox(height: 25.h,),
//         const StudentDetailsForm(),
//
//       ],
//     );
//   }
// }
