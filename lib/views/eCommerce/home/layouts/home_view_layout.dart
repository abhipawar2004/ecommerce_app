import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_grocery/components/ecommerce/app_logo.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/eCommerce/category/category_controller.dart';
import 'package:ready_grocery/controllers/eCommerce/flash_sales/flash_sales_controller.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/category/category.dart';
import 'package:ready_grocery/models/eCommerce/order/order_model.dart';
import 'package:ready_grocery/models/eCommerce/product/product.dart' as product;
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/services/common/hive_service_provider.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';
import 'package:ready_grocery/utils/global_function.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';
import 'package:ready_grocery/views/eCommerce/categories/components/sub_categories_bottom_sheet.dart';
import 'package:ready_grocery/views/eCommerce/checkout/components/address_modal_bottom_sheet.dart';
import 'package:ready_grocery/views/eCommerce/home/components/category_card.dart';
import 'package:ready_grocery/views/eCommerce/home/components/home_shimmer_loader.dart';
import 'package:ready_grocery/views/eCommerce/home/components/popular_product_card.dart';
import 'package:ready_grocery/views/eCommerce/home/components/shop_card.dart';
import 'package:ready_grocery/views/eCommerce/home/components/view_more.dart';
import 'package:ready_grocery/views/eCommerce/products/layouts/product_details_layout.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../components/ecommerce/custom_search_field.dart';
import '../../../../controllers/common/master_controller.dart';
import '../../../../controllers/eCommerce/dashboard/dashboard_controller.dart';
import '../../../../models/eCommerce/flash_sales_list_model/running_flash_sale.dart';
import '../../../../models/eCommerce/shop/shop.dart';
import '../components/banner_widget.dart';

class EcommerceHomeViewLayout extends ConsumerStatefulWidget {
  const EcommerceHomeViewLayout({super.key});

  @override
  ConsumerState<EcommerceHomeViewLayout> createState() =>
      _EcommerceHomeViewLayoutState();
}

class _EcommerceHomeViewLayoutState
    extends ConsumerState<EcommerceHomeViewLayout> {
  final TextEditingController productSearchController = TextEditingController();
  PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();

  final List<SubCategory> subCategories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(currentPageController.notifier).state;
      ref.read(flashSalesListControllerProvider.notifier).getFlashSalesList();
    });
    pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    if (mounted) scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    int? newPage = pageController.page?.round();
    if (newPage != ref.read(currentPageController)) {
      setState(() {
        ref.read(currentPageController.notifier).state = newPage!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapperWidget(
      isLoading: ref.watch(subCategoryControllerProvider),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: colors(context).primaryColor,
            surfaceTintColor: GlobalFunction.getContainerColor(),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
        ),
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildAppBarWidget(context),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _SliverAppBarDelegate(
                  child: GestureDetector(
                    onTap: () => context.nav.pushNamed(
                      Routes.getProductsViewRouteName(
                          AppConstants.appServiceName),
                      arguments: [
                        null,
                        'All Product',
                        null,
                        null,
                        null,
                        subCategories,
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32)),
                      child: Container(
                        decoration: _buildContainerDecoration(context),
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 16.h)
                                  .copyWith(top: 0),
                              child: AbsorbPointer(
                                absorbing: true,
                                child: CustomSearchField(
                                  name: 'product_search',
                                  hintText: S.of(context).searchProduct,
                                  hintTextColor: Colors.white60,
                                  textInputType: TextInputType.text,
                                  controller: productSearchController,
                                  widget: Container(
                                    margin: EdgeInsets.all(10.sp),
                                    child: SvgPicture.asset(
                                      Assets.svg.searchHome,
                                      colorFilter: ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                  fillColor:
                                      Colors.white.withValues(alpha: 0.16),
                                  borderColor:
                                      Colors.white.withValues(alpha: 0.32),
                                  borderWidth: 1,
                                ),
                              ),
                            ),
                            // Inner shadow effect at bottom
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: IgnorePointer(
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(32),
                                        bottomRight: Radius.circular(32)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.15),
                                        Colors.black.withValues(alpha: 0.25),
                                      ],
                                      stops: [0.0, 0.7, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ref.watch(dashboardControllerProvider).when(
                data: (dashboardData) => RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(dashboardControllerProvider).value;
                    ref
                        .refresh(flashSalesListControllerProvider.notifier)
                        .stream;
                  },
                  child: AnimationLimiter(
                    child: SingleChildScrollView(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.h,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            Gap(16.h),
                            _buildCategoriesWidget(
                                context, dashboardData.categories),
                            Gap(10.h),
                            BannerWidget(dashboardData: dashboardData),
                            Gap(20.h),
                            FlashInComingSales(),
                            // _buildScrollingContainers(),
                            _buildPopularProductWidget(
                                context, dashboardData.popularProducts),
                            if (ref
                                .read(masterControllerProvider.notifier)
                                .materModel
                                .data
                                .isMultiVendor) ...[
                              _buildShopsWidget(
                                context,
                                dashboardData.shops,
                              ),
                              Divider(
                                  color: colors(context).accentColor,
                                  thickness: 2),
                            ],
                            Gap(10.h),
                            _buildBeautyProductWidget(
                                products: dashboardData.justForYou.products),
                            // Gap(ScreenUtil().screenHeight / 6),
                            Gap(100.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(error.toString(),
                      style: AppTextStyle(context).subTitle),
                ),
                loading: () => HomeShimmerLoader(),
              ),
        ),
      ),
    );
  }

  Widget _buildBeautyProductWidget({required List<product.Product> products}) {
    return Column(
      children: [
        viewMore(
          context,
          title: S.of(context).justForYou,
          onTap: () => context.nav.pushNamed(
            Routes.getProductsViewRouteName(AppConstants.appServiceName),
            arguments: [
              null,
              'Just For You',
              'just_for_you',
              null,
              null,
              subCategories
            ],
          ),
        ),
        GridView.builder(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, top: 0, bottom: 16.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(context),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.w,
            mainAxisExtent: 264.h,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => PopularProductCard(
            width: double.infinity,
            paddingRight: 0,
            product: products[index],
            onTap: () => context.nav.pushNamed(
              Routes.getProductDetailsRouteName(AppConstants.appServiceName),
              arguments: products[index].id,
            ),
            onFavoriteTap: () {
              ref
                  .read(dashboardControllerProvider.notifier)
                  .toggleFavourite(products[index], isJustForYouProduct: true);
            },
          ),
          // ProductCard(
          //   product: products[index],
          //   onTap: () => context.nav.pushNamed(
          //     Routes.getProductDetailsRouteName(AppConstants.appServiceName),
          //     arguments: products[index].id,
          //   ),
          // ),
        ),

        _buildViewMoreButton(context, 'Just For You', 'just_for_you')
        // Positioned(
        //     left: 20.w,
        //     child: viewMore(context, title: S.of(context).justForYou, onTap: () => context.nav.pushNamed(
        //       Routes.getProductsViewRouteName(AppConstants.appServiceName),
        //       arguments: [null, 'Just For You', 'just_for_you', null, null, subCategories],
        //     ),),
        //     // child: Text(S.of(context).justForYou,
        //     //     style: AppTextStyle(context).subTitle)
        // ),
        // Positioned(
        //   bottom: 20.h,
        //   left: 20.w,
        //   right: 20.w,
        //   child: _buildViewMoreButton(context, 'Just For You', 'just_for_you'),
        // ),
      ],
    );
  }

  Widget _buildCategoriesWidget(
      BuildContext context, List<Category> categories) {
    bool isDark = isDarkMode();

    return Container(
      color: isDark
          ? EcommerceAppColor.gray.withValues(alpha: 0.3)
          : EcommerceAppColor.gray50,
      height: 140.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSectionHeader(context, S.of(context).categories,
              Routes.getCategoriesViewRouteName(AppConstants.appServiceName)),
          // Gap(10.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final category = categories[index];
                return SizedBox(
                  // height: 200,
                  width: 100,
                  child: CategoryCard(
                    maxLines: 1,
                    category: category,
                    padding: EdgeInsets.zero,
                    onTap: () {
                      if (category.subCategories.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SubCategoriesBottomSheet(
                            category: category,
                          ),
                        );
                      } else {
                        GlobalFunction.navigatorKey.currentContext!.nav
                            .pushNamed(
                          Routes.getProductsViewRouteName(
                            AppConstants.appServiceName,
                          ),
                          arguments: [
                            category.id,
                            category.name,
                            null,
                            null,
                            null,
                            category.subCategories,
                          ],
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       Gap(10.w),
          //       ...categories.map(
          //         (category) => CategoryCard(
          //           category: category,
          //           onTap: () {
          //             if (category.subCategories.isNotEmpty) {
          //               showModalBottomSheet(
          //                 context: context,
          //                 builder: (context) => SubCategoriesBottomSheet(
          //                   category: category,
          //                 ),
          //               );
          //             } else {
          //               GlobalFunction.navigatorKey.currentContext!.nav
          //                   .pushNamed(
          //                 Routes.getProductsViewRouteName(
          //                   AppConstants.appServiceName,
          //                 ),
          //                 arguments: [
          //                   category.id,
          //                   category.name,
          //                   null,
          //                   null,
          //                   null,
          //                   category.subCategories,
          //                 ],
          //               );
          //             }
          //           },
          //         ),
          //       ),
          //       Gap(10.w),
          //     ],
          //   ),
          // ),
          // Gap(10.h),
        ],
      ),
    );
  }

  Widget _buildShopsWidget(
    BuildContext context,
    List<Shop> shops,
  ) {
    return Container(
      color: isDarkMode()
          ? EcommerceAppColor.gray.withValues(alpha: 0.3)
          : EcommerceAppColor.gray50,
      child: Column(
        children: [
          _buildSectionHeader(context, S.of(context).shops,
              Routes.getShopsViewRouteName(AppConstants.appServiceName)),
          SizedBox(
            height: MediaQuery.of(context).size.height / 8.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: shops.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: ShopCardCircle(
                  callback: () => context.nav.pushNamed(
                    Routes.getShopViewRouteName(AppConstants.appServiceName),
                    arguments: shops[index].id,
                  ),
                  shop: shops[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularProductWidget(
      BuildContext context, List<product.Product> products) {
    return Container(
      decoration: BoxDecoration(color: GlobalFunction.getContainerColor()),
      child: Column(
        children: [
          _buildSectionHeader(context, S.of(context).popularProducts,
              Routes.getProductsViewRouteName(AppConstants.appServiceName),
              arguments: [
                null,
                'Popular',
                'popular',
                null,
                null,
                subCategories
              ]),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16.w, top: 4, bottom: 4),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) => PopularProductCard(
                product: products[index],
                onTap: () => context.nav.pushNamed(
                  Routes.getProductDetailsRouteName(
                      AppConstants.appServiceName),
                  arguments: products[index].id,
                ),
                onFavoriteTap: () {
                  ref
                      .read(dashboardControllerProvider.notifier)
                      .toggleFavourite(products[index]);
                },
              ),
            ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }

  Widget _buildAppBarWidget(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(AppConstants.userBox).listenable(),
      builder: (context, userBox, _) {
        return Container(
          color: colors(context).primaryColor,
          padding: EdgeInsets.only(left: 4.w, bottom: 20.h, top: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ref.read(hiveServiceProvider).userIsLoggedIn()
                  ? _buildHeaderRow(context)
                  : const AppLogo(
                      isAnimation: true,
                      centerAlign: false,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String route,
      {List<dynamic>? arguments}) {
    return viewMore(context,
        title: title,
        onTap: () => context.nav.pushNamed(route, arguments: arguments));
  }

  Widget _buildViewMoreButton(
      BuildContext context, String title, String argument) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: OutlinedButton(
        onPressed: () => context.nav.pushNamed(
          Routes.getProductsViewRouteName(AppConstants.appServiceName),
          arguments: [null, title, argument, null, null, subCategories],
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: colors(context).primaryColor?.withValues(alpha: 0.1),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          side: BorderSide(
            color: colors(context).primaryColor!,
            width: 1,
          ),
          minimumSize: Size(MediaQuery.of(context).size.width, 45.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
        child: Text(S.of(context).viewMore,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                fontSize: 14,
                color: colors(context).primaryColor,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Decoration _buildContainerDecoration(BuildContext context) {
    // Color color = Colors.red;
    return BoxDecoration(
      color: colors(context).primaryColor,
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      // boxShadow: [
      //   _customShadow(context, color: color),
      // ],
    );
  }

  // BoxShadow _customShadow(BuildContext context, {required Color color,}) {
  //   return BoxShadow(
  //     color: color,
  //     offset: Offset(0, -3), // Negative Y for upward shadow
  //     blurRadius: 8,
  //     spreadRadius: -2, // Negative spread creates inset effect
  //     blurStyle: BlurStyle.inner,
  //   );
  // }

  Widget _buildHeaderRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftRow(context),
          GestureDetector(
            onTap: () => context.nav.pushNamed(
                Routes.getNotificationRouteName(AppConstants.appServiceName)),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: SvgPicture.asset(Assets.svg.notificationWhite,
                  height: 24.h, width: 24.w, fit: BoxFit.fill),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeftRow(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          barrierColor: colors(context).accentColor!.withValues(alpha: 0.8),
          context: context,
          builder: (_) => const AddressModalBottomSheet(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).location,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.7))),
                ValueListenableBuilder(
                  valueListenable: Hive.box(AppConstants.userBox).listenable(),
                  builder: (context, box, _) {
                    final addressData =
                        box.get(AppConstants.defaultAddress, defaultValue: "");
                    debugPrint(
                        "Retrieved addressData: $addressData, Type: ${addressData.runtimeType}");

                    return Text(
                      addressData.isNotEmpty
                          ? _defaultAddress(context, addressData)
                          : "Select your location",
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    );
                  },
                )
              ],
            )),
            Gap(8.w),
            Icon(Icons.expand_more, color: colors(context).light),
          ],
        ),
      ),
    );
  }

  String _defaultAddress(BuildContext context, dynamic data) {
    if (data == null) return '';

    try {
      Address address = Address.fromJson(data);

      return GlobalFunction.formatDeliveryAddress(
          context: context, address: address);
    } catch (e) {
      debugPrint("Error parsing address data: $e");
      return '';
    }
  }
}

int _calculateCrossAxisCount(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > 600 ? 3 : 2;
}

class FlashInComingSales extends ConsumerWidget {
  const FlashInComingSales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(flashSalesListControllerProvider.notifier);
    return Container(
      color: isDarkMode() ? Colors.black : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          notifier.inComingFlashSales.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: notifier.inComingFlashSales.length,
                  itemBuilder: (context, index) {
                    final sale = notifier.inComingFlashSales[index];
                    return DealOfTheDayWidget(
                      runningSaleData: sale,
                      showViewMore: true,
                    );
                  })
              : SizedBox.shrink(),
          notifier.runningFlashSales.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: notifier.runningFlashSales.length,
                  itemBuilder: (context, index) {
                    final sale = notifier.runningFlashSales[index];
                    return DealOfTheDayWidget(
                      runningSaleData: sale,
                      showViewMore: true,
                    );
                  })
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class DealOfTheDayWidget extends ConsumerWidget {
  final bool showViewMore;
  final RunningFlashSale runningSaleData;
  // final String title;
  const DealOfTheDayWidget({
    super.key,
    this.showViewMore = true,
    required this.runningSaleData,
    // required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? endDate;
    if (runningSaleData.endDate != null) {
      endDate = DateTime.parse(runningSaleData.endDate ?? "");
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 15.h),
            height: 56.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(39.r),
                image: DecorationImage(
                    image: Assets.png.flashDealBg.provider(),
                    fit: BoxFit.fill)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          runningSaleData.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyle(context).subTitle.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFC107)),
                        ),
                      ),
                      Gap(4.w),
                      SvgPicture.asset(
                        "assets/svg/fire.svg",
                        height: 24.h,
                        width: 24.w,
                      ),
                    ],
                  ),
                ),
                Gap(10.w),
                if (showViewMore)
                  _buildViewMoreButton(
                    context,
                    ref,
                    runningSaleData.id,
                    runningSaleData.name ?? "",
                  ),
              ],
            ),
          ),
          if (endDate != null)
            SlideCountdownSeparated(
              separatorStyle: AppTextStyle(context)
                  .bodyText
                  .copyWith(color: Colors.transparent),
              style: AppTextStyle(context).title.copyWith(
                  color: FoodAppColor.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.w),
                  color: EcommerceAppColor.black,
                  shape: BoxShape.circle),
              duration: endDate.isAfter(DateTime.now())
                  ? endDate.difference(DateTime.now())
                  : Duration.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildViewMoreButton(
      BuildContext context, WidgetRef ref, id, String title) {
    return InkWell(
      onTap: () {
        ref
            .read(flashSaleDetailsControllerProvider.notifier)
            .getFlashSalesDetails(id: id);
        context.nav.pushNamed(Routes.flashSaleDetails, arguments: title);
      },
      child: Text(
        S.of(context).viewMore,
        textAlign: TextAlign.end,
        style: AppTextStyle(context)
            .bodyTextSmall
            .copyWith(color: colors(context).light),
      ),
    );
  }
}

// Widget _buildScrollingContainers() {
//   return SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     physics: const NeverScrollableScrollPhysics(),
//     child: Row(
//       children: List.generate(
//         60,
//         (index) => Container(
//           margin: const EdgeInsets.symmetric(horizontal: 2),
//           height: 2.h,
//           width: 5.w,
//           color: EcommerceAppColor.lightGray.withValues(alpha: 0.5),
//         ),
//       ),
//     ),
//   );
// }

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 60.h;

  @override
  double get minExtent => 60.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
