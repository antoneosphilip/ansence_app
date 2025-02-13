import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom_Cached_network/cusotm_chaced_netwok.dart';

void showImageDialog(BuildContext context, String? imageUrl) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: Container(
          width: double.infinity,
          height: 400.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: CustomCachedImage(imageUrl: imageUrl, size: 400.h,isReact: false,),
        ),
      ),
    ),
  );
}