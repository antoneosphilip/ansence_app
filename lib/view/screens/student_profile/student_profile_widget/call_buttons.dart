import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/model/get_missing_student_model/get_missing_student_model.dart';

import 'call_button_item.dart';

class CallButtons extends StatelessWidget {
  final GetMissingStudentModel getMissingStudentModel;

  const CallButtons({super.key, required this.getMissingStudentModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getMissingStudentModel.dadPhone != null &&
                  getMissingStudentModel.mamPhone != null
              ? 16.w
              : 5.w,
        ),
        getMissingStudentModel.dadPhone != null
            ? Expanded(
                child: CallButton(
                text: 'الاتصال بالأب',
                phoneNumber: getMissingStudentModel.dadPhone!,
              ))
            : const SizedBox(),
        SizedBox(
          width: 16.w,
        ),
        getMissingStudentModel.mamPhone != null
            ? Expanded(
                child: CallButton(
                text: 'الاتصال بالأم',
                phoneNumber: getMissingStudentModel.mamPhone!,
              ))
            : const SizedBox(),
        SizedBox(
          width: getMissingStudentModel.dadPhone != null &&
                  getMissingStudentModel.mamPhone != null
              ? 16.w
              : 20.w,
        ),
      ],
    );
  }
}
