import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summer_school_app/view/screens/search/screen_widget/student_search_result_item.dart';

class StudentSearchResultListView extends StatelessWidget {
  const StudentSearchResultListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index)
        {
          return const StudentSearchResultItem();
        },
        separatorBuilder: (context,index)
        {
          return SizedBox(height: 40.h,);
        },
        itemCount: 5);
  }
}
