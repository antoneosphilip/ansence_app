import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/core_widget/custom_error/custom_error.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';

import 'missing_student_item.dart';

class MissingStudentListView extends StatelessWidget {
  const MissingStudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissingCubit, MissingStates>(
      buildWhen: (previous, current) =>
      current is GetMissingStudentSuccessState||
      current is GetMissingStudentLoadingState ||
      current is GetMissingStudentErrorState,
      builder: (BuildContext context, state) {
        return state is GetMissingStudentLoadingState
            ? const CustomLoading()
            : state is GetMissingStudentErrorState
                ? const CustomError()
                : state is GetMissingStudentSuccessState
                    ? Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return  MissingStudentItem( studentMissingModel: MissingCubit.get(context).studentMissingModel[index],);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 35.h,
                              );
                            },
                            itemCount: MissingCubit.get(context).studentMissingModel.length),
                        SizedBox(height: 10.h,)
                      ],
                    )
                    : const SizedBox();
      },
    );
  }
}
