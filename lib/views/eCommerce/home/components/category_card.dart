// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/models/eCommerce/category/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.padding,
    this.maxLines = 2,
    this.flex = 3,
  });

  final Category category;
  final void Function()? onTap;
  final EdgeInsets? padding;
  final int maxLines;
  final int flex;

  @override
  Widget build(BuildContext context) {
    // bool isDark = isDarkMode();
    return Padding(
      padding: padding ?? EdgeInsets.all(4.0.r),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
                width: 72.w,
                height: 56.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(category.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: flex,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.all(2.0.r).copyWith(top: 0),
                child: Text(
                  category.name,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
