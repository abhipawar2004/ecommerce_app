// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';

class CustomSearchField extends StatelessWidget {
  final String name;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final Widget? widget;
  final void Function(String?)? onChanged;
  final Color? borderColor;
  final Color? fillColor;
  final Color? hintTextColor;
  final double? borderWidth;
  final double? contentPaddingVertical;
  const CustomSearchField({
    super.key,
    required this.name,
    this.focusNode,
    required this.hintText,
    required this.textInputType,
    required this.controller,
    required this.widget,
    this.onChanged,
    this.borderColor,
    this.fillColor,
    this.borderWidth,
    this.contentPaddingVertical,
    this.hintTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = 67;
    return FormBuilderTextField(
      textAlign: TextAlign.start,
      name: name,
      focusNode: focusNode,
      controller: controller,
      style: AppTextStyle(context).bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
      cursorColor: colors(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle(context).bodyText.copyWith(
              fontWeight: FontWeight.w400,
              color: hintTextColor ?? colors(context).hintTextColor,
              fontSize: 14.sp,
            ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: contentPaddingVertical ?? 12),
        alignLabelWithHint: true,
        prefixIcon: widget,
        prefixIconConstraints: BoxConstraints(maxWidth: 50),
        floatingLabelStyle: AppTextStyle(context).bodyText.copyWith(
              fontWeight: FontWeight.w400,
              color: colors(context).primaryColor,
            ),
        filled: true,
        fillColor: fillColor ?? colors(context).accentColor,
        errorStyle: AppTextStyle(context).bodyTextSmall.copyWith(
              fontWeight: FontWeight.w400,
              color: colors(context).errorColor,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.r),
          borderSide: BorderSide(
            width: borderWidth ?? 1,
            color: borderColor ??
                colors(context).accentColor ??
                EcommerceAppColor.offWhite,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.r),
          borderSide: BorderSide(
            color: borderColor ??
                colors(context).accentColor ??
                EcommerceAppColor.offWhite,
            width: borderWidth ?? 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ??
                colors(context).accentColor ??
                EcommerceAppColor.offWhite,
            width: borderWidth ?? 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      onChanged: onChanged,
      keyboardType: textInputType,
    );
  }
}
