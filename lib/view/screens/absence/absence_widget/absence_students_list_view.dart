import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/student_item_offline.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/stuent_item.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../view_model/block/absence_cubit/absence_cubit.dart';
import '../../../core_widget/custom_error/custom_error.dart';

class AbsenceStudentListView extends StatelessWidget {
  const AbsenceStudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsenceCubit,AbsenceStates>(
      buildWhen: (previous, current) =>
      current is GetAbsenceSuccessState ||
          current is GetAbsenceErrorState ||
          current is GetAbsenceLoadingState,
      builder: (BuildContext context, state) {
        return state is GetAbsenceLoadingState
            ? const CustomLoading()
            : state is GetAbsenceSuccessState
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return StudentAbsenceItem(
                            studentAbsenceModel: AbsenceCubit.get(context)
                                .studentAbsenceModel[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 35.h,
                          );
                        },
                        itemCount: AbsenceCubit.get(context)
                            .studentAbsenceModel
                            .length),
                  )
                : state is GetAbsenceErrorState
                    ? const CustomError()
                    : const SizedBox();
      },
    );
  }
}
