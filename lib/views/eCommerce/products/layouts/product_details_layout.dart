// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/components/ecommerce/app_bar.dart';
import 'package:ready_grocery/components/ecommerce/app_logo.dart';
import 'package:ready_grocery/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_grocery/components/ecommerce/custom_button.dart';
import 'package:ready_grocery/components/ecommerce/custom_transparent_button.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/common/master_controller.dart';
import 'package:ready_grocery/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_grocery/controllers/eCommerce/dashboard/dashboard_controller.dart';
import 'package:ready_grocery/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/cart/add_to_cart_model.dart';
import 'package:ready_grocery/models/eCommerce/product/product_details.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/services/common/hive_service_provider.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';
import 'package:ready_grocery/utils/global_function.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';
import 'package:ready_grocery/views/eCommerce/products/components/product_color_picker.dart';
import 'package:ready_grocery/views/eCommerce/products/components/product_description.dart';
import 'package:ready_grocery/views/eCommerce/products/components/product_details_and_review.dart';
import 'package:ready_grocery/views/eCommerce/products/components/product_image_page_view.dart';
import 'package:ready_grocery/views/eCommerce/products/components/product_size_picker.dart';
import 'package:ready_grocery/views/eCommerce/products/components/shop_info.dart';
import 'package:ready_grocery/views/eCommerce/products/components/similar_products_widget.dart';
import 'package:shimmer/shimmer.dart';

class EcommerceProductDetailsLayout extends ConsumerStatefulWidget {
  final int productId;
  const EcommerceProductDetailsLayout({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<EcommerceProductDetailsLayout> createState() =>
      _EcommerceProductDetailsLayoutState();
}

class _EcommerceProductDetailsLayoutState
    extends ConsumerState<EcommerceProductDetailsLayout> {
  bool isTextExpanded = false;
  bool isFavorite = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didpop, result) {
        ref.read(productControllerProvider.notifier).getFavoriteProducts();
        ref.invalidate(dashboardControllerProvider);
        ref.invalidate(selectedSizePriceProvider);
        ref.invalidate(selectedColorPriceProvider);
      },
      child: LoadingWrapperWidget(
        isLoading: ref.watch(cartController).isLoading,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Scaffold(
            backgroundColor: colors(context).accentColor,
            bottomNavigationBar: ref
                .watch(productDetailsControllerProvider(widget.productId))
                .whenOrNull(
                  data: (productDetails) => _buildBottomNavigationBar(
                      context: context, productDetails: productDetails),
                ),
            body: Stack(
              children: [
                ref
                    .watch(productDetailsControllerProvider(widget.productId))
                    .when(
                      data: (productDetails) => SingleChildScrollView(
                        child: AnimationLimiter(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 500),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                  verticalOffset: 50.h,
                                  child: FadeInAnimation(
                                    child: widget,
                                  )),
                              children: [
                                // Gap(2.h),
                                ProductImagePageView(
                                  productDetails: productDetails,
                                  height: 396,
                                ),
                                // Gap(14.h),
                                ProductDescription(
                                    productDetails: productDetails),
                                Gap(productDetails.product.colors.isNotEmpty
                                    ? 8.h
                                    : 0),
                                Visibility(
                                  visible:
                                      productDetails.product.colors.isNotEmpty,
                                  child: ProductColorPicker(
                                      productDetails: productDetails),
                                ),
                                Gap(productDetails
                                        .product.productSizeList.isNotEmpty
                                    ? 14.h
                                    : 0),
                                Visibility(
                                  visible: productDetails
                                      .product.productSizeList.isNotEmpty,
                                  child: ProductSizePicker(
                                      productDetails: productDetails),
                                ),
                                Visibility(
                                  visible: ref
                                      .read(masterControllerProvider.notifier)
                                      .materModel
                                      .data
                                      .isMultiVendor,
                                  child: Gap(14.h),
                                ),
                                Visibility(
                                    visible: ref
                                        .read(masterControllerProvider.notifier)
                                        .materModel
                                        .data
                                        .isMultiVendor,
                                    child: ShopInformation(
                                        productDetails: productDetails)),
                                Gap(8.h),
                                Container(
                                    height: 8.h,
                                    width: double.infinity,
                                    color: isDarkMode()
                                        ? colors(context).dark
                                        : colors(context).light),
                                // Gap(8.h),
                                ProductDetailsAndReview(
                                  productDetails: productDetails,
                                ),
                                // Gap(16.h),
                                SimilarProductsWidget(
                                  productDetails: productDetails,
                                  productId: widget.productId,
                                ),
                                // Gap(16.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      error: ((error, stackTrace) => Center(
                            child: Text(
                              error.toString(),
                            ),
                          )),
                      loading: () => ProductDetailShimmer(),
                    ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: mainAppbar(context,
                      leadingCircleColor: Colors.white,
                      backgroundColor: Colors.transparent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _buildAppBarRightRow({required BuildContext context}) {
  //   return SizedBox(
  //     child: Padding(
  //       padding: EdgeInsets.only(right: 20.w, bottom: 6.h),
  //       child: Row(
  //         children: [
  //           CustomCartWidget(context: context),
  //           // Gap(10.w),
  //           // SvgPicture.asset(
  //           //   Assets.svg.share,
  //           //   width: 52.w,
  //           // )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  _buildBottomNavigationBar(
      {required BuildContext context, required ProductDetails productDetails}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: Theme.of(context).scaffoldBackgroundColor,
      // height: 112.h,
      child: IntrinsicHeight(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "${S.of(context).price}: ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyText.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  if (productDetails.product.discountPrice > 0) ...[
                    Flexible(
                      child: Text(
                        GlobalFunction.price(
                          ref: ref,
                          price: (productDetails.product.discountPrice +
                                  ref.watch(selectedColorPriceProvider) +
                                  ref.watch(selectedSizePriceProvider))
                              .toString(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle(context).bodyText.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                    ),
                  ] else ...[
                    Text(
                      GlobalFunction.price(
                        ref: ref,
                        price: (productDetails.product.price +
                                ref.watch(selectedColorPriceProvider) +
                                ref.watch(selectedSizePriceProvider))
                            .toString(),
                      ),
                      style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 16.sp),
                    ),
                  ],
                ],
              ),
              Gap(8.h),
              Row(
                children: [
                  Expanded(
                    // flex: 1,
                    child: AbsorbPointer(
                      absorbing: productDetails.product.quantity == 0,
                      child: CustomTransparentButton(
                        buttonTextColor: productDetails.product.quantity == 0
                            ? ColorTween(
                                begin: colors(context).primaryColor,
                                end: colors(context).light,
                              ).lerp(0.5)
                            : colors(context).primaryColor,
                        borderColor: productDetails.product.quantity == 0
                            ? ColorTween(
                                begin: colors(context).primaryColor,
                                end: colors(context).light,
                              ).lerp(0.5)
                            : colors(context).primaryColor,
                        buttonText: S.of(context).addToCart,
                        onTap: () => _onTapCart(productDetails, false),
                      ),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    // flex: 1,
                    child: AbsorbPointer(
                      absorbing: productDetails.product.quantity == 0,
                      child: CustomButton(
                          buttonText: S.of(context).buyNow,
                          buttonColor: productDetails.product.quantity == 0
                              ? ColorTween(
                                  begin: colors(context).primaryColor,
                                  end: colors(context).light,
                                ).lerp(0.5)
                              : colors(context).primaryColor,
                          onPressed: () => _onTapCart(productDetails, true)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapCart(ProductDetails productDetails, bool isBuyNow) async {
    final AddToCartModel addToCartModel = AddToCartModel(
      productId: productDetails.product.id,
      quantity: 1,
      size: productDetails.product.productSizeList.isNotEmpty
          ? productDetails
              .product.productSizeList[ref.read(selectedProductSizeIndex)].id
          : null,
      color: productDetails.product.colors.isNotEmpty
          ? productDetails
              .product.colors[ref.read(selectedProductColorIndex)!].id
          : null,
    );
    if (!ref.read(hiveServiceProvider).userIsLoggedIn()) {
      _showTheWarningDialog();
    } else {
      await ref
          .read(cartController.notifier)
          .addToCart(addToCartModel: addToCartModel);

      if (isBuyNow) {
        context.nav.pushNamed(
            Routes.getMyCartViewRouteName(
              AppConstants.appServiceName,
            ),
            arguments: [false, isBuyNow]);
      }
    }
  }

  _showTheWarningDialog() {
    showDialog(
      barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
          .accentColor!
          .withValues(alpha: 0.8),
      context: GlobalFunction.navigatorKey.currentContext!,
      builder: (_) => ConfirmationDialog(
        title: S.of(context).youAreNotLoggedIn,
        confirmButtonText:
            S.of(GlobalFunction.navigatorKey.currentContext!).login,
        onPressed: () {
          GlobalFunction.navigatorKey.currentContext!.nav
              .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        },
      ),
    );
  }
}

class LoadingWrapperWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const LoadingWrapperWidget({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          const Center(
            child: AppLogo(
              withAppName: false,
              isAnimation: true,
            ),
          ),
      ],
    );
  }
}

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Placeholder
          ShimmerWidget.rectangular(height: 250, borderRadius: 12),
          const SizedBox(height: 20),

          // Product Name Placeholder
          ShimmerWidget.rectangular(height: 20, width: 200),
          const SizedBox(height: 10),

          // Price Placeholder
          ShimmerWidget.rectangular(height: 20, width: 120),
          const SizedBox(height: 20),

          // Review | Sold | Share Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangular(height: 16, width: 80),
              ShimmerWidget.rectangular(height: 16, width: 80),
              ShimmerWidget.rectangular(height: 16, width: 80),
            ],
          ),
          const SizedBox(height: 20),

          // Description Title Placeholder
          ShimmerWidget.rectangular(height: 18, width: 100),
          const SizedBox(height: 10),

          // Description Content Placeholder
          ShimmerWidget.rectangular(height: 14, width: double.infinity),
          const SizedBox(height: 6),
          ShimmerWidget.rectangular(height: 14, width: double.infinity),
          const SizedBox(height: 6),
          ShimmerWidget.rectangular(height: 14, width: 180),
          const SizedBox(height: 20),

          // Add to Cart Button Placeholder
          ShimmerWidget.rectangular(height: 45, borderRadius: 8),
        ],
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerWidget.rectangular({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode();

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
