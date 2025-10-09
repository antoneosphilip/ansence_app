import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/utility/database/local/cache_helper.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_cubit.dart';
import 'package:summer_school_app/view_model/block/missing_cubit/missing_states.dart';
import 'package:summer_school_app/view_model/repo/missing_repo/missing_repo.dart';

import '../../../../core/service_locator/service_locator.dart';
import '../../../core_widget/absence_appbar/absence_appbar.dart';
import '../../../core_widget/custom_drop_down/custom_drop_down.dart';
import '../../../core_widget/custom_top_sncak_bar/custom_top_snack_bar.dart';
import '../missing_widget/missing_list_view.dart';

class MissingScreen extends StatelessWidget {
  const MissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MissingCubit(sl.get<MissingRepo>()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocConsumer<MissingCubit, MissingStates>(
            buildWhen: (previous, current) =>
                current is GetMissingStudentSuccessState ||
                current is GetMissingStudentErrorState ||
                current is GetMissingStudentLoadingState
              ||current is UpdateStudentMissingSuccessState,
            listener: (context, state) {
              if(state is CompleteAllStudentMissingSuccessState ){
                showSnackBarWidget(context," شكرا لافتقادك يا ${CacheHelper.getDataString(key: 'name')}");
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AbsenceAppbar(
                    text: 'الافتقاد',
                  ),
                  SizedBox(height: 15.h),
                  const CustomDropDown(
                    isAbsence: false,
                  ),
                  SizedBox(height: 20.h),
                  MissingStudentListView(
                      missingCubit: MissingCubit.get(context), state: state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
