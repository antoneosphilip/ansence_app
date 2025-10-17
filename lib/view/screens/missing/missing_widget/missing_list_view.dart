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

class MissingStudentListView extends StatefulWidget {
  final MissingCubit missingCubit;
  final MissingStates state;
  final bool fromStatusMissing;
  final String? numberClass;
  const MissingStudentListView({super.key, required this.missingCubit, required this.state,  this.fromStatusMissing=false,  this.numberClass, });

  @override
  State<MissingStudentListView> createState() => _MissingStudentListViewState();
}

class _MissingStudentListViewState extends State<MissingStudentListView> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.fromStatusMissing) {
      if(widget.numberClass!=null) {
        MissingCubit.get(context)
            .getAbsenceMissing(id: int.parse(widget.numberClass ?? '0'));
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.state is GetMissingStudentLoadingState
        ? const Center(child: CustomLoading())
        : widget.state is GetMissingStudentErrorState
        ? const CustomError()
        : (widget.state is GetMissingStudentSuccessState|| widget.state is UpdateStudentMissingSuccessState)&&
    widget.missingCubit.studentMissingModelList.isNotEmpty
        ? Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MissingStudentItem(
                studentMissingModel: MissingCubit.get(context)
                    .studentMissingModelList[index],
                missingCubit: widget.missingCubit,
                  numberClass:widget.numberClass??'0',
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
    (widget.state is GetMissingStudentSuccessState|| widget.state is UpdateStudentMissingSuccessState)&&
    widget.missingCubit.studentMissingModelList.isEmpty?
    const CustomNoData()
        : const SizedBox();
  }
}
