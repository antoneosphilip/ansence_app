import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/core/Custom_Text/custom_text.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/route_manager/page_name.dart';
import 'package:summer_school_app/view/core_widget/text_form_field/text_form_field_custom.dart';
import 'package:summer_school_app/view/screens/search/screen_widget/student_search_result_list_view.dart';

class SearchScreenWidget extends StatelessWidget {
  const SearchScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
      child: Column(
        children: [
          TextFormFieldCustom(
            validate: (String? value)
            {
            },
            hint: "Search for a student",
            suffix: true,
            suffixIcon: const Icon(Icons.search),
          ),
          SizedBox(height: 25.h,),
          const StudentSearchResultListView(),

        ],
      ),
    );
  }
}
