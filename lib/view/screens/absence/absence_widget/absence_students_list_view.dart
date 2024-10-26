import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/screens/absence/absence_widget/student_item.dart';

class AbsenceStudentListView extends StatelessWidget {
  const AbsenceStudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index)
        {
          return const StudentAbsenceItem();
        },
        separatorBuilder: (context,index)
        {
          return SizedBox(height: 35.h,);
        },
        itemCount: 5);
  }
}
