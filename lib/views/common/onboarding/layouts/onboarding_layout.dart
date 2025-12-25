import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/components/ecommerce/custom_button.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/routes.dart';
import 'package:ready_grocery/services/common/hive_service_provider.dart';
import 'package:ready_grocery/utils/context_less_navigation.dart';

class OnboardingLayout extends ConsumerStatefulWidget {
  const OnboardingLayout({super.key});

  @override
  ConsumerState<OnboardingLayout> createState() => _OnboardingLayoutState();
}

class _OnboardingLayoutState extends ConsumerState<OnboardingLayout> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      int? newPage = pageController.page?.round();
      if (newPage != ref.read(currentPageController)) {
        setState(() {
          ref.read(currentPageController.notifier).state = newPage!;
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: onboardingItems.length,
        onPageChanged: (page) {
          if (page == 2 && !ref.read(isOnboardingLastPage)) {
            ref.read(isOnboardingLastPage.notifier).state = true;
          } else if (ref.read(isOnboardingLastPage)) {
            ref.read(isOnboardingLastPage.notifier).state = false;
          }
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Image.asset(
                onboardingItems[index]['image'],
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  // height: 236.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  margin: EdgeInsets.only(top: 8.h),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24.sp)),
                      color: Colors.white.withValues(alpha: 0.8)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: ref
                                          .read(currentPageController.notifier)
                                          .state ==
                                      index
                                  ? colors(context).primaryColor
                                  : EcommerceAppColor.white,
                              borderRadius: BorderRadius.circular(30.sp),
                            ),
                            height: 8.h,
                            width: ref
                                        .read(currentPageController.notifier)
                                        .state ==
                                    index
                                ? 26
                                : 8.w,
                          ),
                        ).toList(),
                      ),
                      Gap(30.h),
                      Text(
                        onboardingItems[index]['title'],
                        textAlign: TextAlign.center,
                        style: AppTextStyle(context).title.copyWith(
                            fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                      Gap(20.h),
                      Text(
                        onboardingItems[index]['description'],
                        style: AppTextStyle(context)
                            .bodyTextSmall
                            .copyWith(fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                      Gap(40.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonText: 'Skip',
                              buttonColor: EcommerceAppColor.white,
                              buttonTextColor: EcommerceAppColor.black,
                              onPressed: () {
                                ref
                                    .read(hiveServiceProvider)
                                    .setFirstOpenValue(value: true);
                                context.nav.pushNamedAndRemoveUntil(
                                    Routes.getCoreRouteName(
                                        AppConstants.appServiceName),
                                    (route) => false);
                              },
                            ),
                          ),
                          Gap(20.w),
                          Expanded(
                            child: CustomButton(
                              buttonText: 'Next',
                              buttonColor: colors(context).primaryColor,
                              onPressed: () {
                                if (index < onboardingItems.length - 1) {
                                  pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                } else {
                                  ref
                                      .read(hiveServiceProvider)
                                      .setFirstOpenValue(value: true);
                                  context.nav.pushNamedAndRemoveUntil(
                                      Routes.getCoreRouteName(
                                          AppConstants.appServiceName),
                                      (route) => false);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  final List<Map<String, dynamic>> onboardingItems = [
    {
      'image': Assets.png.onboardingOne.path,
      'title': 'Shop from Anywhere, Anytime',
      'description':
          'Browse and buy from top stores and thousands of products, all in the palm of your hand.'
    },
    {
      'image': Assets.png.onboardingTwo.path,
      'title': 'Simple Steps, Big Savings',
      'description':
          'Add to cart, pay securely, and get your order fast — shopping has never been this smooth.'
    },
    {
      'image': Assets.png.onboardingThree.path,
      'title': 'Shop Smart with Amazing Discounts',
      'description':
          'Discover the Convenience of Grocery Shopping at Your Fingertips'
    },
  ];
}
