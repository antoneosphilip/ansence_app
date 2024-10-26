import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/color_manager/color_manager.dart';
import '../../../core/style_font_manager/style_manager.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding:  EdgeInsets.only(right: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint:  Row(
            children: [
              const Icon(
                Icons.list,
                size: 16,
                color: ColorManager.colorWhite,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'اختر فصل',
                  style:TextStyleManager.textStyle20w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50.h,
            width: 160.w,
            padding:  EdgeInsets.only(left: 14.w, right: 14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: ColorManager.colorPrimary,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: ColorManager.colorWhite,
            iconDisabledColor: ColorManager.colorWhite,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200.h,
            width: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorManager.colorPrimary,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData:  MenuItemStyleData(
            height: 40.h,
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
          ),
        ),
      ),
    );
  }
}
