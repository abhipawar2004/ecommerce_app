import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/components/ecommerce/add_to_cart_bottom_sheet.dart';
import 'package:ready_grocery/components/ecommerce/increment_button.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/models/eCommerce/product/product.dart';
import 'package:ready_grocery/utils/global_function.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';

class PopularProductCard extends ConsumerWidget {
  final Product product;
  final void Function()? onTap;
  final double? width;
  final double? paddingRight;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final void Function() onFavoriteTap;
  const PopularProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width,
    this.paddingRight,
    this.margin,
    this.boxShadow,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = isDarkMode();
    return Padding(
      padding: margin ?? EdgeInsets.only(right: paddingRight ?? 10.w),
      child: Material(
        borderRadius: BorderRadius.circular(8.0.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0.r),
          onTap: onTap,
          child: Container(
            width: width ?? 220.w,
            decoration: BoxDecoration(
                color: GlobalFunction.getContainerColor(),
                borderRadius: BorderRadius.circular(8.0.r),
                border: isDark
                    ? Border.all(color: Colors.white.withValues(alpha: 0.2))
                    : null,
                boxShadow: boxShadow ??
                    [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180.h,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                              product.thumbnail,
                            ))),
                        alignment: AlignmentGeometry.bottomCenter,
                        padding: EdgeInsets.all(2.r),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.discountPercentage != 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(13.r),
                                        color: EcommerceAppColor.red,
                                      ),
                                      child: Text(
                                        '-${product.discountPercentage}%',
                                        style: AppTextStyle(context)
                                            .bodyTextSmall
                                            .copyWith(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: colors(context).light,
                                            ),
                                      ),
                                    ),
                                  Gap(8.w),
                                  GestureDetector(
                                    onTap: onFavoriteTap,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.16),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 1),
                                            ),
                                          ]),
                                      child: product.isFavorite
                                          ? Icon(
                                              Icons.favorite,
                                              // size: 30.sp,
                                              color: colors(context).errorColor,
                                            )
                                          : SvgPicture.asset(
                                              "assets/svg/heart.svg",
                                              color: isDark
                                                  ? Colors.white
                                                  : EcommerceAppColor.black,
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: EcommerceAppColor.white),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 16.sp,
                                        color: EcommerceAppColor.carrotOrange,
                                      ),
                                      Text(
                                        product.rating.toString(),
                                        style: AppTextStyle(context)
                                            .bodyTextSmall
                                            .copyWith(
                                                color: EcommerceAppColor.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.sp),
                                      ),
                                      Gap(5.w),
                                      Text(
                                        '(${product.totalReviews})',
                                        style: AppTextStyle(context)
                                            .bodyTextSmall
                                            .copyWith(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF617986)),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: EcommerceAppColor.white),
                                  child: Text(
                                    '${product.totalSold} Sold',
                                    style: AppTextStyle(context)
                                        .bodyTextSmall
                                        .copyWith(
                                            color: EcommerceAppColor.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Positioned(
                      //   top: 6.h,
                      //   right: 6.w,
                      //   child: Container(
                      //       padding: const EdgeInsets.all(4),
                      //       decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: Colors.white,
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black.withValues(alpha: 0.16),
                      //               spreadRadius: 1,
                      //               blurRadius: 10,
                      //               offset: const Offset(0, 1),
                      //             ),
                      //           ]),
                      //       child: Image.asset(
                      //         "assets/png/heart.png",
                      //         width: 22.w,
                      //       )),
                      // ),
                      // if (product.discountPercentage != 0)
                      //   Positioned(
                      //     top: 6.h,
                      //     left: 6.w,
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 4.w, vertical: 1.h),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30.r),
                      //         color: EcommerceAppColor.red,
                      //       ),
                      //       child: Text(
                      //         '-${product.discountPercentage}%',
                      //         style:
                      //             AppTextStyle(context).bodyTextSmall.copyWith(
                      //                   fontSize: 10.sp,
                      //                   fontWeight: FontWeight.w500,
                      //                   color: colors(context).light,
                      //                 ),
                      //       ),
                      //     ),
                      //   ),
                      if (product.quantity == 0) ...[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                            child: Center(
                              child: Text(
                                'Out of Stock',
                                style: AppTextStyle(context).subTitle.copyWith(
                                      color: colors(context).light,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r).copyWith(bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Gap(2.h),
                        Text(
                          "${product.name}\n",
                          style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (product.discountPrice > 0)
                                    Flexible(
                                      child: Text(
                                        GlobalFunction.price(
                                          ref: ref,
                                          price: product.price.toString(),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle(context)
                                            .bodyText
                                            .copyWith(
                                              color:
                                                  EcommerceAppColor.lightGray,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 12.sp,
                                            ),
                                      ),
                                    ),
                                  Gap(4.w),
                                  Flexible(
                                    child: Text(
                                      GlobalFunction.price(
                                        ref: ref,
                                        price: (product.discountPrice > 0
                                                ? product.discountPrice
                                                : product.price)
                                            .toString(),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle(context)
                                          .bodyText
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Right Button
                            IncrementButton(
                              onTap: () {
                                ref
                                    .refresh(selectedProductColorIndex.notifier)
                                    .state;
                                ref
                                    .refresh(selectedProductSizeIndex.notifier)
                                    .state;

                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  builder: (_) =>
                                      AddToCartBottomSheet(product: product),
                                );
                              },
                            ),
                          ],
                        ),
                        Gap(product.discountPrice > 0 ? 10.h : 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
