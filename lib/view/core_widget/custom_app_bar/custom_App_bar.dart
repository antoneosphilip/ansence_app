import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../app_bar_custom/app_bar_custom.dart';



class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final List<Widget>? actions;
  final bool isIcon;
  const AppBarCustom({super.key, required this.name, this.actions,  this.isIcon=true});

  @override
  Widget build(BuildContext context) {
    return  CustomAppBar (
      title: name.tr,
      font:20,
      fontWeight: FontWeight.bold,
      iconSize: 20,
      actions:actions,
      backgroundColor: Colors.white,
      isIcon: isIcon,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(60.0); // Adjust the height here
}
