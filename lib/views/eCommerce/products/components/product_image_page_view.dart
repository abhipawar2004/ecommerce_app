import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/components/ecommerce/network_image.dart';
import 'package:ready_grocery/components/ecommerce/zoom_able_image.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/models/eCommerce/product/product_details.dart';
import 'package:ready_grocery/views/eCommerce/products/components/iframe_card.dart';
import 'package:ready_grocery/views/eCommerce/products/components/video_player.dart';

import '../../../../config/app_constants.dart';

class ProductImagePageView extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  final double height;
  const ProductImagePageView({
    super.key,
    required this.productDetails,
    this.height = 416,
  });

  @override
  ConsumerState<ProductImagePageView> createState() =>
      _ProductImagePageViewState();
}

class _ProductImagePageViewState extends ConsumerState<ProductImagePageView> {
  PageController pageController = PageController();
  @override
  void initState() {
    // ignore: unused_result
    Future.microtask(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var _ = ref.refresh(currentPageController);
        pageController.addListener(() {
          int? newPage = pageController.page?.round();
          if (newPage != ref.read(currentPageController)) {
            setState(() {
              ref.read(currentPageController.notifier).state = newPage!;
            });
          }
        });
      });
      Future.delayed(Duration.zero)
          .then((_) => ref.read(currentPageController.notifier).state = 0);
    });
    super.initState();
  }

  ScrollController scrollController = ScrollController();
  final int visibleItems = 5;
  void scrollToSelected(int index) {
    // item width + margin approximation
    double itemWidth = 50.w + 8.w; // 50 width + 4+4 margin
    double screenWidth = MediaQuery.of(context).size.width;
    double offset = index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    scrollController.animateTo(
      offset.clamp(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double itemWidth = screenWidth / visibleItems;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: widget.height.h,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.productDetails.product.thumbnails.length,
            itemBuilder: (context, index) {
              final products = widget.productDetails.product;
              final fileSystem = products.thumbnails[index].type;
              final url = products.thumbnails[index].thumbnail;
              if (fileSystem == FileSystem.image.name) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ZoomAbleImageView(
                                  url: url,
                                )));
                  },
                  child: networkImage(
                    url ?? '',
                    fit: BoxFit.contain,
                  ),
                );
              } else if (fileSystem == FileSystem.file.name) {
                return VideoPlayer(
                  videoUrl:
                      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
                      url ?? '',
                );
              } else {
                return Container(
                  padding: EdgeInsets.only(top: 100.h),
                  width: double.infinity,
                  child: IframeCard(
                    iframeUrl: url ?? '',
                  ),
                );
              }
            },
          ),
        ),
        Positioned(
          bottom: 8.h,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              height: 50.h,
              width: 282.w,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double listWidth = constraints.maxWidth;
                  double maxItemWidth = 50.w;
                  double minItemWidth = 50.w;
                  double itemMargin = 4.w;

                  return ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productDetails.product.thumbnails.length,
                    itemBuilder: (context, index) {
                      final bool isSelected =
                          ref.watch(currentPageController) == index;

                      double itemWidth =
                          isSelected ? maxItemWidth : minItemWidth;

                      return GestureDetector(
                        onTap: () {
                          // update selected index
                          ref.read(currentPageController.notifier).state =
                              index;

                          // animate PageView
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );

                          // scroll to center
                          double offset =
                              (index * (maxItemWidth + itemMargin)) -
                                  (listWidth / 2) +
                                  (itemWidth / 2);

                          scrollController.animateTo(
                            offset.clamp(
                              scrollController.position.minScrollExtent,
                              scrollController.position.maxScrollExtent,
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: itemWidth,
                          width: itemWidth,
                          margin:
                              EdgeInsets.symmetric(horizontal: itemMargin / 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors(context).light
                                : Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: networkImage(
                              widget.productDetails.product.thumbnails[index]
                                  .thumbnail,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
