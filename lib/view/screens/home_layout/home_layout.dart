import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/view/screens/home/home_screen/home_screen.dart';
import 'package:summer_school_app/view_model/block/layout_cubit/layout_cubit.dart';
import 'package:summer_school_app/view_model/block/layout_cubit/layout_states.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
    return  BlocProvider(
      create: (BuildContext context) =>LayoutCubit(),
      child: BlocBuilder<LayoutCubit,LayoutStates>(
        builder: (BuildContext context, LayoutStates state) {
          final cubit=LayoutCubit.get(context);
          return  Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0, // Use the state variable here
              backgroundColor: Colors.white,
              buttonBackgroundColor: ColorManager.colorPrimary,
              color: ColorManager.colorPrimary,
              height: 70,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              items: const <Widget>[
                Icon(Icons.home_filled, size: 25, color: Colors.white),
              ],
              onTap: (index) {
                cubit.bottomTap(index);
              },
            ),
            body:cubit.pageList[cubit.currIndex], // Use the state variable here
          );
        },

      ),
    );
  }
}
