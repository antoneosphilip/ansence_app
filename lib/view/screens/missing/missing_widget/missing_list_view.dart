import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/core_widget/custom_error/custom_error.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
import 'package:summer_school_app/view/core_widget/custom_no_data/custom_no_data.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';

import 'missing_student_item.dart';

class MissingStudentListView extends StatelessWidget {
  final MissingCubit missingCubit;
  final MissingStates state;
  const MissingStudentListView({super.key, required this.missingCubit, required this.state });

  @override
  Widget build(BuildContext context) {
    return state is GetMissingStudentLoadingState
        ? const Center(child: CustomLoading())
        : state is GetMissingStudentErrorState
        ? const CustomError()
        : (state is GetMissingStudentSuccessState|| state is UpdateStudentMissingSuccessState)&&
    missingCubit.studentMissingModelList.isNotEmpty
        ? Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MissingStudentItem(
                studentMissingModel: MissingCubit.get(context)
                    .studentMissingModelList[index],
                missingCubit: missingCubit,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 35.h,
              );
            },
            itemCount: MissingCubit.get(context)
                .studentMissingModelList
                .length),
        SizedBox(
          height: 10.h,
        )
      ],
    ):
    (state is GetMissingStudentSuccessState|| state is UpdateStudentMissingSuccessState)&&
    missingCubit.studentMissingModelList.isEmpty?
    const CustomNoData()
        : const SizedBox();
  }
}
