import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/components/ecommerce/back_button.dart';
import 'package:ready_grocery/components/ecommerce/custom_cart.dart';
import 'package:ready_grocery/components/ecommerce/custom_search_field.dart';
import 'package:ready_grocery/components/ecommerce/product_not_found.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/category/category.dart';
import 'package:ready_grocery/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';
import 'package:ready_grocery/utils/global_function.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';
import 'package:ready_grocery/views/eCommerce/home/components/popular_product_card.dart';
import 'package:ready_grocery/views/eCommerce/products/components/category_selection.dart';
import 'package:ready_grocery/views/eCommerce/products/components/filter_modal_bottom_sheet.dart';
import 'package:ready_grocery/views/eCommerce/products/components/list_product_card.dart';
import 'package:ready_grocery/views/eCommerce/products/components/product_loader.dart';

import '../../../../controllers/eCommerce/dashboard/dashboard_controller.dart';
import '../../../../controllers/misc/misc_controller.dart';
import '../../../../utils/opacity_primary_color.dart';

class EcommerceProductsLayout extends ConsumerStatefulWidget {
  final int? categoryId;
  final String? sortType;
  final String categoryName;
  final int? subCategoryId;
  final String? shopName;
  final List<SubCategory>? subCategories;

  const EcommerceProductsLayout({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.sortType,
    this.subCategoryId,
    this.shopName,
    this.subCategories,
  });

  @override
  ConsumerState<EcommerceProductsLayout> createState() =>
      _EcommerceProductsLayoutState();
}

class _EcommerceProductsLayoutState
    extends ConsumerState<EcommerceProductsLayout> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool isHeaderVisible = true;
  bool isList = true;
  int page = 1;
  int perPage = 20;
  List<FilterCategory> filterCategoryList = [
    FilterCategory(id: 0, name: 'All')
  ];
  double scrollPosition = 0.0;
  bool isLastPosition = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCategoryByIndex.notifier).state = null;
      ref.watch(productControllerProvider.notifier).products.clear();
      _setSelectedSubCategory(id: widget.subCategoryId ?? 0).then((_) {
        _fetchProducts(isPagination: false);
      });
    });
    _setSubCategory(subCategories: widget.subCategories ?? []);

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    debugPrint("listener");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLastPosition = true;
        scrollPosition = scrollController.position.pixels;
      });
      debugPrint('Call fetch more products');
      _fetchMoreProducts();
    }
  }

  void _fetchProducts({required bool isPagination}) {
    ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
          productFilterModel: ProductFilterModel(
            categoryId: widget.categoryId,
            page: page,
            perPage: perPage,
            search: searchController.text,
            sortType: widget.sortType,
            subCategoryId: ref.watch(selectedSubCategory) != 0
                ? ref.watch(selectedSubCategory)
                : null,
          ),
          isPagination: isPagination,
        );
  }

  void _fetchMoreProducts() {
    final productNotifier = ref.read(productControllerProvider.notifier);
    if (productNotifier.products.length < productNotifier.total! &&
        !ref.watch(productControllerProvider)) {
      page++;
      _fetchProducts(isPagination: true);
    }
  }

  void _setSubCategory({required List<SubCategory> subCategories}) {
    for (SubCategory category in subCategories) {
      filterCategoryList.add(
        FilterCategory(id: category.id, name: category.name),
      );
    }
  }

  Future<void> _setSelectedSubCategory({required int id}) {
    ref.read(selectedSubCategory.notifier).state = id;
    return Future.value();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollAndJump() {
    if (isLastPosition && scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollPosition);
        setState(() {
          isLastPosition = false;
        });
      });
    }
  }

  String? getSelectedCategoryTitle() {
    int? index = ref.watch(selectedCategoryByIndex);
    List<Category> categoryList =
        ref.watch(dashboardControllerProvider).value?.categories ?? [];
    if (index != null && categoryList.isNotEmpty) {
      return categoryList[index].name;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: GlobalFunction.getContainerColor()));
    bool isDark = isDarkMode();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: isDark ? Colors.black : Colors.white,
          ),
        ),
        // resizeToAvoidBottomInset: false,
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: CustomScrollView(
          controller: scrollController,
          // cacheExtent: 150.h,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              centerTitle: false,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor: GlobalFunction.getContainerColor(),
              title: _customHeaderAppBarWidget(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                maxExtentS: widget.subCategories!.isNotEmpty ? 110.h : 62.h,
                child: _buildFilterRow(context),
              ),
            ),
            SliverList(
                delegate:
                    SliverChildBuilderDelegate(childCount: 1, (context, index) {
              scrollAndJump();
              return categorySelection(
                context,
                productFilterModel: ProductFilterModel(
                  page: 1,
                  perPage: 20,
                  categoryId: widget.categoryId,
                ),
              );
            })),
            SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: _buildProductsWidget(context))
          ],
        ));
  }

  Widget _customHeaderAppBarWidget() {
    return _buildHeaderRow(context);
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      color: GlobalFunction.getContainerColor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftRow(context),
          _buildRightRow(context),
        ],
      ),
    );
  }

  Widget _buildLeftRow(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          backButton(context),
          // IconButton(
          //   visualDensity: VisualDensity.compact,
          //   onPressed: () => context.nav.pop(context),
          //   icon: Icon(Icons.arrow_back, size: 24.h),
          // ),
          Gap(16.w),
          Expanded(
            child: Text(
              widget.shopName ??
                  getSelectedCategoryTitle() ??
                  widget.categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context)
                  .subTitle
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Gap(4.w),
        ],
      ),
    );
  }

  Widget _buildRightRow(BuildContext context) {
    bool isDark = isDarkMode();
    return Row(
      children: [
        CustomCartWidget(context: context),
        Gap(16.w),
        GestureDetector(
          onTap: () => _showFilterModal(context),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getOpacityPrimaryColor(context),
            ),
            child: SvgPicture.asset(
              Assets.svg.filter,
              colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : Colors.black, BlendMode.srcIn),
              // color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: GlobalFunction.getContainerColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      context: context,
      builder: (_) => FilterModalBottomSheet(
        productFilterModel: ProductFilterModel(
          page: 1,
          perPage: 20,
          categoryId: widget.categoryId,
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h, bottom: 0),
      color: GlobalFunction.getContainerColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 45.h,
            child: Row(
              children: [
                Expanded(
                  // flex: 5,
                  // fit: FlexFit.tight,
                  child: CustomSearchField(
                    name: 'searchProduct',
                    fillColor: getOpacityPrimaryColor(context),
                    contentPaddingVertical: 0,
                    hintText: S.of(context).searchProduct,
                    textInputType: TextInputType.text,
                    controller: searchController,
                    onChanged: (value) {
                      page = 1;
                      _fetchProducts(isPagination: false);
                    },
                    widget: Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 5.w),
                      child: SvgPicture.asset(
                        Assets.svg.searchHome,
                        colorFilter: ColorFilter.mode(
                          Color(0xFF687387),
                          BlendMode.srcIn,
                        ),
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                Builder(builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getOpacityPrimaryColor(context),
                    ),
                    child: GestureDetector(
                        onTap: () {
                          setState(() => isList = !isList);
                          debugPrint("isList $isList");
                        },
                        child: SvgPicture.asset(
                          isList ? Assets.svg.grid : Assets.svg.list,
                          width: 20.w,
                          height: 20.h,
                        )),
                  );
                }),
              ],
            ),
          ),
          // Gap(8.h),
          // Visibility(
          //     visible: widget.sortType != null,
          //     child: Divider(
          //         color: colors(context).accentColor, height: 2, thickness: 2)),
          Visibility(
            visible:
                widget.sortType == null && widget.subCategories!.isNotEmpty,
            child: _buildFilterListWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterListWidget() {
    return Consumer(builder: (context, ref, _) {
      return Container(
        margin: EdgeInsets.only(top: 8.h),
        height: 35.h,
        color: GlobalFunction.getContainerColor(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filterCategoryList.length,
          itemBuilder: (context, index) {
            debugPrint("selected category1 ${ref.watch(selectedSubCategory)}");
            debugPrint(
                "selected category2 ${ref.watch(selectedSubCategory) == filterCategoryList[index].id}");
            final isSelected =
                ref.watch(selectedSubCategory) == filterCategoryList[index].id;

            debugPrint("isSelected $isSelected");

            return GestureDetector(
              onTap: () {
                if (searchController.text.isNotEmpty) {
                  searchController.clear();
                }
                page = 1;
                if (ref.watch(selectedSubCategory.notifier).state !=
                    filterCategoryList[index].id) {
                  debugPrint(
                      "selected category3 ${filterCategoryList[index].id}");

                  _setSelectedSubCategory(id: filterCategoryList[index].id!)
                      .then((_) {
                    _fetchProducts(isPagination: false);
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: isSelected
                          ? colors(context).primaryColor!
                          : colors(context).accentColor!),
                ),
                child: Center(
                  child: Text(filterCategoryList[index].name,
                      style: AppTextStyle(context).bodyTextSmall),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildProductsWidget(BuildContext context) {
    final productController = ref.watch(productControllerProvider.notifier);
    final isLoading = ref.watch(productControllerProvider);
    final products = productController.products;

    if (isLoading && products.isEmpty) {
      return SliverToBoxAdapter(
        child: productLoader(context, isGrid: !isList),
      );
    }

    if (products.isEmpty) {
      return const SliverToBoxAdapter(
        child: ProductNotFoundWidget(),
      );
    }

    Duration animationDuration = const Duration(milliseconds: 75);

    if (isList) {
      // ✅ List layout
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: animationDuration,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListProductCard(
                    margin: EdgeInsets.only(bottom: 16.h),
                    product: product,
                    onTap: () => context.nav.pushNamed(
                      Routes.getProductDetailsRouteName(
                          AppConstants.appServiceName),
                      arguments: product.id,
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: products.length, // footer extra
        ),
      );
    } else {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return AnimationConfiguration.staggeredGrid(
              duration: animationDuration,
              position: index,
              columnCount: 2,
              child: ScaleAnimation(
                child: PopularProductCard(
                  paddingRight: 0,
                  margin: EdgeInsets.zero,
                  product: product,
                  onTap: () => context.nav.pushNamed(
                    Routes.getProductDetailsRouteName(
                        AppConstants.appServiceName),
                    arguments: product.id,
                  ),
                  onFavoriteTap: () {
                    ref
                        .read(dashboardControllerProvider.notifier)
                        .toggleFavourite(product);
                  },
                ),
              ),
            );
          },
          childCount: products.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 14.w,
          mainAxisExtent: 264.h,
        ),
      );
    }
  }

  final selectedSubCategory = StateProvider<int>((value) => 0);
}

class FilterCategory {
  final int? id;
  final String name;

  FilterCategory({this.id, required this.name});
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
    this.maxExtentS = 80.0,
  });

  final Widget child;
  final double maxExtentS;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxExtentS;

  @override
  double get minExtent => maxExtentS;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// Widget _buildProductsWidget(BuildContext context) {
//   final productController = ref.watch(productControllerProvider.notifier);
//   final products = productController.products;
//
//   if (ref.watch(productControllerProvider)) {
//     return productLoader(context, isGrid: !isList);
//   }
//
//   if (products.isEmpty) {
//     return const ProductNotFoundWidget();
//   }
//
//   return isList
//       ? _buildListProductsWidget(context)
//       : _buildGridProductsWidget(context);
// }
//
// Widget _buildListProductsWidget(BuildContext context) {
//   final products = ref.watch(productControllerProvider.notifier).products;
//
//   return AnimatedContainer(
//     duration: const Duration(milliseconds: 500),
//     child: AnimationLimiter(
//       child: ListView.builder(
//         // controller: scrollController,
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         padding: EdgeInsets.symmetric(vertical: 10.h),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           // if (isLastPosition && scrollController.hasClients) {
//           //   WidgetsBinding.instance.addPostFrameCallback((_) {
//           //     scrollController.jumpTo(scrollPosition);
//           //     setState(() {
//           //       isLastPosition = false;
//           //     });
//           //   });
//           // }
//           final product = products[index];
//           return AnimationConfiguration.staggeredList(
//             position: index,
//             duration: const Duration(milliseconds: 500),
//             child: SlideAnimation(
//               verticalOffset: 50.0,
//               child: FadeInAnimation(
//                 child: ListProductCard(
//                   product: product,
//                   onTap: () => context.nav.pushNamed(
//                     Routes.getProductDetailsRouteName(
//                         AppConstants.appServiceName),
//                     arguments: product.id,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }
//
// Widget _buildGridProductsWidget(BuildContext context) {
//   final products = ref.watch(productControllerProvider.notifier).products;
//
//   return AnimationLimiter(
//     child: GridView.builder(
//       // controller: scrollController,
//       physics: NeverScrollableScrollPhysics(),
//       padding:
//           EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h, bottom: 90.h),
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16.w,
//         mainAxisSpacing: 16.w,
//         mainAxisExtent: 264.h,
//       ),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         // if (isLastPosition && scrollController.hasClients) {
//         //   WidgetsBinding.instance.addPostFrameCallback((_) {
//         //     scrollController.jumpTo(scrollPosition);
//         //     setState(() {
//         //       isLastPosition = false;
//         //     });
//         //   });
//         // }
//         final product = products[index];
//         return AnimationConfiguration.staggeredGrid(
//           duration: const Duration(milliseconds: 375),
//           position: index,
//           columnCount: 2,
//           child: ScaleAnimation(
//             child: PopularProductCard(
//               paddingRight: 0,
//               product: product,
//               onTap: () => context.nav.pushNamed(
//                 Routes.getProductDetailsRouteName(
//                     AppConstants.appServiceName),
//                 arguments: product.id,
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
