import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/student_item.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

import '../../../../view_model/block/absence_cubit/absence_cubit.dart';

class AbsenceStudentListView extends StatelessWidget {
  final AbsenceStates state;

  const AbsenceStudentListView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return state is GetAbsenceLoadingState
        ? const CustomLoading()
        : state is GetAbsenceSuccessState
            ? Padding(
              padding:  EdgeInsets.only(bottom: 10.h),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return StudentAbsenceItem(
                        studentAbsenceModel:
                            AbsenceCubit.get(context).studentAbsenceModel[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 35.h,
                    );
                  },
                  itemCount: AbsenceCubit.get(context).studentAbsenceModel.length),
            )
            : state is GetAbsenceErrorState
                ? const Center(
                    child: Text("there are error please try again"),
                  )
                : const SizedBox();
  }
}
