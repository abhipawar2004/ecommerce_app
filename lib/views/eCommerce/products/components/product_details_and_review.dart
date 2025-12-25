import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/eCommerce/shop/shop_controller.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_grocery/models/eCommerce/product/product_details.dart'
    as product_details;
import 'package:ready_grocery/models/eCommerce/shop/shop_review.dart';
import 'package:ready_grocery/views/eCommerce/products/components/review_card.dart';

import '../../../../utils/is_dark_mode.dart';

class ProductDetailsAndReview extends ConsumerStatefulWidget {
  final product_details.ProductDetails productDetails;
  const ProductDetailsAndReview({super.key, required this.productDetails});

  @override
  ProductDetailsAndReviewState createState() => ProductDetailsAndReviewState();
}

class ProductDetailsAndReviewState
    extends ConsumerState<ProductDetailsAndReview> {
  final ScrollController reviewScrollController = ScrollController();
  bool isProduct = true;
  int page = 1;
  int perPage = 20;
  int? totalReview;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(shopControllerProvider.notifier)
          .getReviews(
            productFilterModel: ProductFilterModel(
              productId: widget.productDetails.product.id,
              page: page,
              perPage: perPage,
            ),
            isPagination: false,
          )
          .whenComplete(() {
        setState(() {
          totalReview = ref.read(shopControllerProvider.notifier).totalReviews;
        });
      });
    });

    super.initState();
  }

  void productScrollListener() {
    if (reviewScrollController.offset >=
        reviewScrollController.position.maxScrollExtent) {
      if (ref.watch(shopControllerProvider.notifier).review.length <
              ref.watch(shopControllerProvider.notifier).totalReviews! &&
          ref.watch(shopControllerProvider) == false) {
        page++;
        ref.read(shopControllerProvider.notifier).getReviews(
              isPagination: true,
              productFilterModel: ProductFilterModel(
                productId: widget.productDetails.product.id,
                page: page,
                perPage: perPage,
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    reviewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 8.h),
      color: isDarkMode() ? colors(context).dark : colors(context).light,
      child: Column(
        children: [
          Container(
              color: colors(context).accentColor,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: _buildProductInfoRow()),
          // Gap(10.h),
          // Divider(
          //   color: colors(context).accentColor,
          // ),
          // Gap(10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: tabBarWidgetView(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isDarkMode() ? colors(context).dark : colors(context).light,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (!isProduct) {
                  _toggleTab();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: isProduct
                      ? colors(context).primaryColor
                      : isDarkMode()
                          ? colors(context).dark
                          : colors(context).light,
                  boxShadow: [
                    if (isProduct)
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                height: 40.h,
                child: Center(
                  child: Text(
                    S.of(context).aboutProduct,
                    style: isProduct
                        ? AppTextStyle(context).bodyText.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)
                        : AppTextStyle(context).bodyTextSmall.copyWith(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (isProduct) {
                  _toggleTab();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: !isProduct
                      ? colors(context).primaryColor
                      : isDarkMode()
                          ? colors(context).dark
                          : colors(context).light,
                  boxShadow: [
                    if (!isProduct)
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                height: 40.h,
                child: Center(
                  child: Text(
                    '${S.of(context).review}($totalReview)',
                    style: !isProduct
                        ? AppTextStyle(context).bodyText.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)
                        : AppTextStyle(context).bodyTextSmall.copyWith(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBarWidgetView() {
    if (isProduct) {
      return _buildHtmlContentView();
    } else {
      return _buildReviewListWidget();
    }
  }

  Widget _buildHtmlContentView() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Html(data: widget.productDetails.product.description),
    );
  }

  Widget _buildReviewListWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: ref.watch(shopControllerProvider)
          ? SizedBox(
              height: 300.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox(
              height:
                  ref.watch(shopControllerProvider.notifier).review.isNotEmpty
                      ? 400.h
                      : null,
              child: ListView.builder(
                controller: reviewScrollController,
                shrinkWrap: true,
                itemCount:
                    ref.watch(shopControllerProvider.notifier).review.length,
                itemBuilder: ((context, index) {
                  final Review review =
                      ref.watch(shopControllerProvider.notifier).review[index];
                  return ReviewCard(review: review);
                }),
              ),
            ),
    );
  }

  void _toggleTab() {
    setState(() {
      isProduct = !isProduct;
    });
  }
}
