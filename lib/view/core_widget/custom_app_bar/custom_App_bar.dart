import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/style_font_manager/style_manager.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios), onPressed: () =>Navigator.pop(context)),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        Padding(
          padding:  EdgeInsets.only(right: 30.w),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 44.h);
}
