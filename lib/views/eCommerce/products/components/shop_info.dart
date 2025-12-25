// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_grocery/components/ecommerce/network_image.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/common/master_controller.dart';
import 'package:ready_grocery/controllers/eCommerce/message/message_controller.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/product/product_details.dart';
import 'package:ready_grocery/models/eCommerce/shop_message_model/shop.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/services/common/hive_service_provider.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';

class ShopInformation extends StatelessWidget {
  final ProductDetails productDetails;
  const ShopInformation({
    super.key,
    required this.productDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: EcommerceAppColor.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          colors(context).primaryColor?.withValues(alpha: 0.4),
                      child: ClipOval(
                        child: networkImage(
                          productDetails.product.shop.logo,
                          width: 44.w,
                          height: 44.w,
                        ),
                      ),
                    ),
                    Gap(8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDetails.product.shop.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle(context).bodyText.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Gap(2.h),
                        Consumer(builder: (context, ref, _) {
                          return Visibility(
                            visible: ref
                                .read(masterControllerProvider.notifier)
                                .materModel
                                .data
                                .isMultiVendor,
                            child: GestureDetector(
                              onTap: () {
                                context.nav.pushNamed(
                                  Routes.getShopViewRouteName(
                                      AppConstants.appServiceName),
                                  arguments: productDetails.product.shop.id,
                                );
                              },
                              child: Text(
                                S.of(context).vistiStore,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(
                                      color: colors(context).primaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      // decoration: TextDecoration.underline,
                                      decorationColor:
                                          colors(context).primaryColor,
                                    ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
                          final saveUser =
                              await ref.read(hiveServiceProvider).getUserInfo();

                          final shop = Shop(
                            id: productDetails.product.shop.id,
                            name: productDetails.product.shop.name,
                            logo: productDetails.product.shop.logo,
                          );

                          ref
                              .read(storeMessageControllerProvider.notifier)
                              .storeMessage(
                                shopId: productDetails.product.shop.id,
                                userId: saveUser!.id!,
                                productId: productDetails.product.id,
                              );
                          context.nav.pushNamed(
                            Routes.getChatViewRouteName(
                                AppConstants.appServiceName),
                            arguments: shop,
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => ConfirmationDialog(
                                    title:
                                        'You can\'t send message without login!',
                                    confirmButtonText: 'Login',
                                    onPressed: () {
                                      context.nav.pushNamedAndRemoveUntil(
                                          Routes.login, (route) => false);
                                    },
                                  ));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: colors(context)
                              .primaryColor!
                              .withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          Assets.svg.messageText,
                          colorFilter: ColorFilter.mode(
                              colors(context).primaryColor!, BlendMode.srcIn),
                          // width: 16.w,
                          // height: 16.h,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Gap(8.h),
            Divider(
              color: EcommerceAppColor.gray.withValues(alpha: 0.4),
            ),
            Gap(8.h),
            _buildShopInfoRow(
              icon: Assets.svg.clock,
              text: S.of(context).estdTime,
              value: productDetails.product.shop.estimatedDeliveryTime,
              context: context,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildShopInfoRow(
      {required String icon,
      required String text,
      required String value,
      required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              SvgPicture.asset(icon,
                  colorFilter: ColorFilter.mode(
                      EcommerceAppColor.white.withValues(alpha: 0.8),
                      BlendMode.srcIn)),
              Gap(4.w),
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: EcommerceAppColor.white.withValues(alpha: 0.8),
                      ),
                ),
              )
            ],
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: EcommerceAppColor.white.withValues(alpha: 0.8),
                ),
          ),
        )
      ],
    );
  }
}
