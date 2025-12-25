import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/models/eCommerce/dashboard/dashboard.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';

class BannerWidget extends ConsumerStatefulWidget {
  final Dashboard dashboardData;
  const BannerWidget({super.key, required this.dashboardData});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDark = isDarkMode();
    return widget.dashboardData.banners.isEmpty
        ? SizedBox(height: 0.h)
        : Column(
            children: [
              CarouselSlider.builder(
                itemCount: widget.dashboardData.banners.length,
                itemBuilder: (context, index, realIndex) {
                  return Card(
                    elevation: 4, // Just like Material Card
                    margin: EdgeInsets.only(
                        bottom: 10.0.h, left: 5.0.w, right: 5.0.w, top: 6.0.h),
                    color: Colors
                        .transparent, // So that inner Container's color works
                    shadowColor: isDark
                        ? Colors.black12
                        : const Color(0xFFBFCEE2), // soft bottom shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Container(
                      // padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        // color: Colors.white, // Needed for shadow to show up
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : const Color(
                                          0xFFBFCEE2), // exact CSS color
                                  offset: const Offset(0, 2), // like 0 2px
                                  blurRadius: 10, // like 10px
                                  spreadRadius: 0, // like 0
                                ),
                              ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl:
                              widget.dashboardData.banners[index].thumbnail,
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 150.0.h,
                  autoPlay: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  autoPlayInterval: const Duration(seconds: 2),
                  viewportFraction: 0.8,
                  enlargeFactor: 0.35,
                  onPageChanged: (index, reason) {
                    ref.read(currentPageController.notifier).state = index;
                  },
                ),
              ),
              Gap(2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.dashboardData.banners.length,
                  (index) {
                    final isSelected =
                        ref.watch(currentPageController) == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors(context).primaryColor
                            : colors(context)
                                .primaryColor!
                                .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      height: 10.h,
                      width: isSelected ? 18.w : 10.w,
                    );
                  },
                ),
              ),
            ],
          );
  }
}
