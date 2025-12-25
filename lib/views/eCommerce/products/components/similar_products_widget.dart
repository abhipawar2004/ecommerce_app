// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/category/category.dart';
import 'package:ready_grocery/models/eCommerce/product/product_details.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';
import 'package:ready_grocery/views/eCommerce/home/components/popular_product_card.dart';

import '../../../../utils/is_dark_mode.dart';
import '../../home/components/view_more.dart';

class SimilarProductsWidget extends ConsumerWidget {
  final ProductDetails productDetails;
  final int productId;
  const SimilarProductsWidget({
    super.key,
    required this.productDetails,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<SubCategory> subCategories = [];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: isDarkMode() ? colors(context).dark : colors(context).light,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          viewMore(context, title: S.of(context).similarProducts, onTap: () {
            context.nav.pushNamed(
              Routes.getProductsViewRouteName(AppConstants.appServiceName),
              arguments: [
                null,
                'All Product',
                null,
                null,
                null,
                subCategories,
              ],
            );
          }),
          SizedBox(
            height: 279.h,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 20.w),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: productDetails.relatedProducts.length,
              itemBuilder: ((context, index) {
                final product = productDetails.relatedProducts[index];
                return PopularProductCard(
                  product: product,
                  margin: EdgeInsets.only(
                    right: 16.w,
                    bottom: 16.h,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 0),
                    ),
                  ],
                  onTap: () {
                    context.nav.popAndPushNamed(
                      Routes.getProductDetailsRouteName(
                          AppConstants.appServiceName),
                      arguments: product.id,
                    );
                  },
                  onFavoriteTap: () {
                    ref
                        .read(productDetailsControllerProvider(productId)
                            .notifier)
                        .toggleFavourite(product);
                  },
                );
              }),
            ),
          ),
          // Gap(40.h)
        ],
      ),
    );
  }
}
