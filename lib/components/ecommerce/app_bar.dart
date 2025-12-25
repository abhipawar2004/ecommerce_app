import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/components/ecommerce/back_button.dart';
import 'package:ready_grocery/components/ecommerce/custom_cart.dart';

AppBar mainAppbar(
  BuildContext context, {
  String? title,
  bool showLeading = true,
  bool showCart = true,
  Color? leadingCircleColor,
  Color? backgroundColor,
  Function()? onBack,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: backgroundColor,
    leading: Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: backButton(context, onTap: onBack, color: leadingCircleColor),
    ),
    title: Text(title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
    centerTitle: false,
    actions: [
      showCart
          ? Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: CustomCartWidget(context: context),
            )
          : SizedBox.shrink()
    ],
  );
}
