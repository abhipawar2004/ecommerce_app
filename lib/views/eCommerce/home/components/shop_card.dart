// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/models/eCommerce/shop/shop.dart';

class ShopCardCircle extends StatelessWidget {
  final Shop shop;
  final VoidCallback callback;
  const ShopCardCircle({
    super.key,
    required this.shop,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: InkWell(
        onTap: callback,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.4),
                  BlendMode.darken,
                ),
                image: CachedNetworkImageProvider(
                  shop.banner,
                ),
                fit: BoxFit.cover),
          ),
          height: 90.h,
          width: 150.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Column(
              children: [
                Spacer(),
                ClipOval(
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.7),
                    child: CachedNetworkImage(
                      imageUrl: shop.logo,
                      height: 40.h,
                      width: 40.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).bodyText.copyWith(
                      color: EcommerceAppColor.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp),
                ),
                Gap(5.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
