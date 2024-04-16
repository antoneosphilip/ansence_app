import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/color_manager/color_manager.dart';



class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final FormFieldValidator<String>? validate;
  final Function(String?)? onSaved;
  final Function()? onEditingComplete;
  final bool obSecure;
  final Widget? prefixIcon;
  final bool prefix;

  final Widget? suffixIcon;
  final bool suffix;
  final Function? suffixOnPressed;
  final TextInputType? keyboardType;
  final int maxDigit;
  final Function? onChanged;
  final TextInputAction? textInputAction;
  final Function? onTab;
  final FocusNode? focus;
  final TextAlign align;
  final String? initial;
  final bool? enable;
  final double? padding;
  final int? maxLines;
  final Color? fillColor;
  final Color? boarderColor;
  final Color ? inputTextColor;


  const TextFormFieldCustom(
      {Key? key,
        this.controller,
        this.label,
        this.hint,
        this.inputTextColor,
        this.obSecure = false,
        this.prefixIcon,
        this.prefix = false,
        this.suffixIcon,
        this.suffix = false,
        this.suffixOnPressed,
        required this.validate,
        this.keyboardType,
        this.maxDigit = 100,
        this.onChanged,
        this.textInputAction,
        this.onTab,
        this.onSaved,
        this.onEditingComplete,
        this.focus,
        this.align = TextAlign.start,
        this.initial,
        this.enable,
        this.fillColor = ColorManager.colorGrey,
        this.boarderColor =ColorManager.colorPrimary,
        this.padding = 22.0,
        this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      textAlignVertical: TextAlignVertical.center,
      textAlign: align,
      focusNode: focus,
      // // autofocus: true,
      enabled: enable,
      initialValue: initial,

      controller: controller,
      textInputAction: textInputAction ?? TextInputAction.next,
      onChanged:  onChanged != null?
          (value)
      {
        onChanged!(value);
      } : null,
      onEditingComplete: onEditingComplete,
      obscureText: obSecure,
      validator: validate,
      onSaved: onSaved,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      onTap: () {
        onTab != null ? onTab!() : null;
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxDigit),
      ],
      style: TextStyle(
        color: ColorManager.colorBlack,
        fontWeight: FontWeight.bold,
        fontSize: 14.4.sp,
      ),
      //maxLength: maxDigit,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor==ColorManager.colorGrey!?fillColor?.withOpacity(.20):fillColor,
        isDense: true,
        //floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          borderSide:  BorderSide(
            color: boarderColor!.withOpacity(.20),
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:  BorderSide(
            color: ColorManager.colorGrey!.withOpacity(.20),
            width: 1.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: padding!,
          horizontal: 22,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:  BorderSide(
            color: boarderColor!,
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        // suffixIconColor: ColorManager.textFormIconColor,
        // focusColor: ColorManager.textFormColor,

        prefixIcon: prefix
            ? Padding(
          padding: EdgeInsets.all(13.0.sp),
          child: prefixIcon,
        )
            : null,
        suffixIcon: suffix
            ? Padding(
          padding: EdgeInsets.all(13.0.sp),
          child: InkWell(
            onTap: suffixOnPressed != null
                ? () {
              suffixOnPressed!();
              // suffixOnPressed!();
            }
                : null,
            child: suffixIcon,
          ),
        )
            : null,
        labelText: label,
        hintText: hint,

        hintStyle: TextStyle(
          color: ColorManager.colorBlack,
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
        ),
        labelStyle: TextStyle(
          color: ColorManager.colorBlack,
          fontSize: 14.sp,
          fontWeight: FontWeight.w300,
        ),
        floatingLabelStyle: TextStyle(
          color:ColorManager.colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),

    );
  }
}
