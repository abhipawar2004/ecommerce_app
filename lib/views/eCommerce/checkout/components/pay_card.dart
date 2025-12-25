// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';

class PayCard extends StatelessWidget {
  final bool isActive;
  final String type;
  final Image image;
  final void Function() onTap;
  const PayCard({
    super.key,
    required this.isActive,
    required this.type,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: ShapeDecoration(
                color: isActive
                    ? colors(context).primaryColor?.withValues(alpha: 0.1)
                    : isDarkMode()
                        ? Colors.black
                        : Color(0xFFF6F7F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    width: 2,
                    color: isActive
                        ? EcommerceAppColor.primary.withValues(alpha: 0.2)
                        : colors(context).accentColor!,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    Assets.svg.radio,
                    width: 20.sp,
                    colorFilter: ColorFilter.mode(
                      isActive
                          ? colors(context).primaryColor!
                          : Colors.grey.shade400,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap(16.h),
                  Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontSize: 14.sp,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? Colors.black : null),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 14.h,
          right: 14.w,
          child: image,
        )
      ],
    );
  }
}
