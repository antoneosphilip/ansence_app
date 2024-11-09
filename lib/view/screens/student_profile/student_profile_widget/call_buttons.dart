import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summer_school_app/model/get_missing_student_model/get_missing_student_model.dart';

import '../../../../core/color_manager/color_manager.dart';
import '../../../../view_model/block/missing_cubit/missing_cubit.dart';
import '../../../core_widget/call_button_whatsapp/call_buttom_whatsapp.dart';
import 'call_button_item.dart';

class CallButtons extends StatelessWidget {
  final GetMissingStudentModel getMissingStudentModel;

  const CallButtons({super.key, required this.getMissingStudentModel});

  @override
  Widget build(BuildContext context) {
    return !checkClass(getMissingStudentModel.studentClass!)
        ? Row(
            children: [
              SizedBox(
                width: getMissingStudentModel.dadPhone != null &&
                        getMissingStudentModel.mamPhone != null
                    ? 16.w
                    : getMissingStudentModel.dadPhone != null &&
                            getMissingStudentModel.mamPhone == null
                        ? 30.w
                        : getMissingStudentModel.dadPhone == null &&
                                getMissingStudentModel.mamPhone != null
                            ? 10.w
                            : 0.w,
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
                    : getMissingStudentModel.dadPhone != null &&
                            getMissingStudentModel.mamPhone == null
                        ? 10.w
                        : getMissingStudentModel.dadPhone == null &&
                                getMissingStudentModel.mamPhone != null
                            ? 25.w
                            : 0.w,
              ),
            ],
          )
        : getMissingStudentModel.studPhone != null
            ? Row(
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                    child: CallButtonWhatsapp(
                      onTab: (){
                        MissingCubit.get(context)
                            .makeDirectCall('0${getMissingStudentModel.studPhone}');
                      }
                      , text: 'الأتصال بالطالب',
                      svg: 'assets/images/call.svg',
                    )
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                      child: CallButtonWhatsapp(
                        onTab: (){
                          MissingCubit.get(context)
                              .openWhatsApp(getMissingStudentModel.studPhone!);
                        }
                        , text: 'مراسلة', svg: 'assets/images/whastapp.svg',)
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              )
            : const SizedBox();
  }
}

bool checkClass(int classId) {
  return (classId == 101 || classId == 102 || classId == 202 || classId == 301);
}
