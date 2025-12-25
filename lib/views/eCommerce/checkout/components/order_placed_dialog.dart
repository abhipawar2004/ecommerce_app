import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:ready_grocery/components/ecommerce/custom_button.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/cart/hive_cart_model.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';

class OrderPlacedDialog extends ConsumerWidget {
  Widget? customButton;
  String? orderId;
  OrderPlacedDialog({super.key, this.customButton, this.orderId});

  // get ref => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Center(
                child: Image.asset("assets/png/tik.png"),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).yourOrderHasBeenPlaced,
              textAlign: TextAlign.center,
              style: AppTextStyle(context)
                  .subTitle
                  .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16.h),
            // RichText(
            //   text: TextSpan(
            //       text: S.of(context).ur_order_id,
            //       style: AppTextStyle(context).bodyText.copyWith(
            //             fontSize: 16.sp,
            //             fontWeight: FontWeight.w400,
            //           ),
            //       children: [
            //         TextSpan(
            //             text: " #$orderId",
            //             style: AppTextStyle(context).bodyText.copyWith(
            //                 fontSize: 16.sp,
            //                 fontWeight: FontWeight.w700,
            //                 color: colors(context).primaryColor)),
            //       ]),
            // ),
            // SizedBox(height: 16.h),
            Text(
              S.of(context).orderPlaceDes,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).bodyText,
            ),
            SizedBox(height: 16.h),
            customButton ??
                CustomButton(
                  buttonText: S.of(context).continueShopping,
                  onPressed: () {
                    Hive.box<HiveCartModel>(AppConstants.cartModelBox).clear();
                    ref.refresh(selectedTabIndexProvider.notifier).state;
                    context.nav.pushNamedAndRemoveUntil(
                        Routes.getCoreRouteName(AppConstants.appServiceName),
                        (route) => false);
                  },
                )
          ],
        ),
      ),
    );
  }
}
