// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
//
// import '../../../core/color_manager/color_manager.dart';
// import '../../../core/style_font_manager/style_manager.dart';
//
// class AppBarWidget extends StatelessWidget {
//   final String? text;
//   final double? rightPadding;
//   final double? rightPaddingText;
//   final double? height;
//   final double? bottomIcon;
//   final double? bottomText;
//   final bool? isSearch;
//   final bool? isArrow;
//   final bool isDarkProfile;
//
//   const AppBarWidget(
//       {super.key,
//         this.text,
//         this.rightPadding = 114,
//         this.rightPaddingText = 154,
//         this.height = 124,
//         this.bottomIcon = 40,
//         this.bottomText = 39,
//         this.isSearch = false, this.isArrow=true,  this.isDarkProfile=false});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ProfileCubit,ProfileStates>(
//       listener: (context,state){},
//       builder: (context,state){
//         return Container(
//           width: ScreenUtil().screenWidth,
//           height: height!.h,
//           decoration: BoxDecoration(
//             color: ProfileCubit.get(context).isDark?ColorManager.colorLightDark:ColorManager.colorPrimary,
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(16.w),
//                 bottomRight: Radius.circular(16.w)),
//           ),
//           child: Row(
//             children: [
//               const Spacer(),
//               Center(
//                 child: Row(
//                   children: [
//                     isDarkProfile?
//                     Padding(
//                       padding:  EdgeInsets.only(right: 40.w),
//                       child: InkWell(
//                         onTap: (){
//                           ProfileCubit.get(context).ChangeAppMode();
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ProfileCubit.get(context).isDark?
//                             const Icon(Icons.light_mode,color: Colors.white,size: 30,):
//                             const Icon(Icons.dark_mode,size: 30,color: Colors.white,),
//                             SizedBox(width: 40.w,),
//                           ],
//                         ),
//                       ),
//                     ):
//                     const SizedBox(),
//
//                     isArrow==true?
//                     InkWell(
//                         onTap: (){
//                           Get.back();
//                         },
//                         child: SvgPicture.asset(AssetsImage.arrowLeft,color: ColorManager.colorWhite,))
//                         :const SizedBox(),
//                     isArrow==false?
//                     SizedBox(width: 10.w,):
//                     SizedBox(width: 60.w,),
//                     Text(
//                       text!.tr,
//                       style: TextStyleManager.textStyle24w500.copyWith(fontSize: 22.sp,color: ColorManager.colorWhite),
//                     ),
//                     isArrow==false?
//                     SizedBox(width: 10.w,):
//                     SizedBox(width: 60.w,),
//                     isDarkProfile? SizedBox(width: 40.w,):const SizedBox(),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//
//               SizedBox(width: 20.w,)
//
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
//
