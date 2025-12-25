import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';

import '../../../../config/theme.dart';
import '../../../../generated/l10n.dart';

Widget viewMore(BuildContext context,
    {required String title, required void Function() onTap}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.h).copyWith(right: 4.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle(context).title.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode() ? Colors.white : Color(0xFF06161C)),
          ),
        ),
        Gap(8.w),
        TextButton(
          onPressed: onTap,
          child: Text(S.of(context).viewMore,
              style: AppTextStyle(context).bodyText.copyWith(
                  color: colors(context).primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );
}
