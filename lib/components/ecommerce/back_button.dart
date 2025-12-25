import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';

Widget backButton(BuildContext context, {Function()? onTap, Color? color}) {
  return CircleAvatar(
      radius: 20.r,
      backgroundColor:
          isDarkMode() ? Colors.black12 : color ?? Colors.transparent,
      child: IconButton(
          onPressed: onTap ?? () => Navigator.pop(context),
          icon: SvgPicture.asset(
            Assets.svg.arrowLeft,
            height: 24.h,
            width: 24.w,
            colorFilter: ColorFilter.mode(
                isDarkMode() ? Colors.white : Colors.black, BlendMode.srcIn),
          )));
}
