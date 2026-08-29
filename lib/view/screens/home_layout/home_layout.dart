import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/view_model/block/layout_cubit/layout_cubit.dart';
import 'package:summer_school_app/view_model/block/layout_cubit/layout_states.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutStates>(
        builder: (BuildContext context, LayoutStates state) {
          final cubit = LayoutCubit.get(context);
          return Scaffold(
            body: cubit.pageList[cubit.currIndex],
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: ColorManager.colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.colorDarkBlue.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.home_rounded,
                      label: 'الرئيسية',
                      isSelected: cubit.currIndex == 0,
                      onTap: () => cubit.bottomTap(0),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      label: 'الإعدادات',
                      isSelected: cubit.currIndex == 1,
                      onTap: () => cubit.bottomTap(1),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.colorPrimary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? ColorManager.colorPrimary
                  : ColorManager.colorXXGrey,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: ColorManager.colorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
