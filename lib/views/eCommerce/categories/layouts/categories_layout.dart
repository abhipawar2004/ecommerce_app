import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ready_grocery/components/ecommerce/app_bar.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/controllers/eCommerce/category/category_controller.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';
import 'package:ready_grocery/utils/global_function.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';
import 'package:ready_grocery/views/eCommerce/categories/components/sub_categories_bottom_sheet.dart';
import 'package:ready_grocery/views/eCommerce/home/components/category_card.dart';
import 'package:ready_grocery/views/eCommerce/products/layouts/product_details_layout.dart';

class EcommerceCategoriesLayout extends ConsumerWidget {
  const EcommerceCategoriesLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int columnCount = 3;
    bool isDark = isDarkMode();
    return LoadingWrapperWidget(
      isLoading: ref.watch(subCategoryControllerProvider),
      child: Scaffold(
        appBar: mainAppbar(context, title: 'All Categories'),
        // appBar: AppBar(
        //   title: const Text('All Categories'),
        //   toolbarHeight: 80.h,
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 16.0),
        //       child: CustomCartWidget(
        //         context: context,
        //       ),
        //     ),
        //   ],
        // ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: Consumer(
          builder: (context, ref, _) {
            final asyncValue = ref.watch(categoryControllerProvider);
            return asyncValue.when(
              data: (categoryList) => AnimationLimiter(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(categoryControllerProvider).value;
                  },
                  child: ListView(
                    children: [
                      Container(
                        color:
                            isDark ? Colors.black : EcommerceAppColor.offWhite,
                        child: GridView.builder(
                          padding: EdgeInsets.all(16.r),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 16.h,
                            crossAxisSpacing: 16.w,
                            // childAspectRatio: 98.w / 105.w,
                            childAspectRatio: 1.05,
                            crossAxisCount: columnCount,
                            // mainAxisExtent: 10
                          ),
                          itemCount: categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: columnCount,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: CategoryCard(
                                      padding: EdgeInsets.zero,
                                      category: categoryList[index],
                                      // TODO need to work here
                                      onTap: () {
                                        if (categoryList[index]
                                            .subCategories
                                            .isNotEmpty) {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                SubCategoriesBottomSheet(
                                              category: categoryList[index],
                                            ),
                                          );
                                        } else {
                                          GlobalFunction
                                              .navigatorKey.currentContext!.nav
                                              .pushNamed(
                                            Routes.getProductsViewRouteName(
                                              AppConstants.appServiceName,
                                            ),
                                            arguments: [
                                              categoryList[index].id,
                                              categoryList[index].name,
                                              null,
                                              null,
                                              null,
                                              categoryList[index].subCategories,
                                            ],
                                          );
                                        }
                                      }),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
