import 'package:flutter/material.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';

import '../../../../core/color_manager/color_manager.dart';

class CallButton extends StatelessWidget {
  final String text;
  final String phoneNumber;
  final Function()? onTab;

  const CallButton({
    super.key,
    required this.text,
    required this.phoneNumber,
    this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColorManager.colorPrimary.withOpacity(0.25),
          width: 1.2,
        ),
        boxShadow: ColorManager.softShadow,
      ),
      child: InkWell(
        onTap: onTab ??
            () {
              MissingCubit.get(context).makeDirectCall('0$phoneNumber');
            },
        borderRadius: BorderRadius.circular(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_in_talk_rounded,
              color: ColorManager.colorPrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: ColorManager.colorPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
