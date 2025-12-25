import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/utils/global_function.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';
import 'package:ready_grocery/views/eCommerce/products/components/filter_modal_bottom_sheet.dart';

import '../../../../controllers/eCommerce/dashboard/dashboard_controller.dart';
import '../../../../controllers/misc/misc_controller.dart';
import '../../../../models/eCommerce/category/category.dart';
import '../../../../models/eCommerce/common/product_filter_model.dart';

Widget categorySelection(
  BuildContext context, {
  required ProductFilterModel productFilterModel,
}) {
  return Consumer(builder: (context, ref, _) {
    final List<Category> categoryList =
        ref.read(dashboardControllerProvider).value?.categories ?? [];
    if (categoryList.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: isDarkMode() ? Colors.blueGrey : Color(0xFFF6F7F9),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final Category category = categoryList[index];
            return categoryCard(context, index, ref,
                category: category,
                isSelected: ref.watch(selectedCategoryByIndex) != null &&
                    ref.watch(selectedCategoryByIndex) == index,
                productFilterModel: productFilterModel);
            // return categoryChip(context, ref, index, category: category, productFilterModel: productFilterModel);
          }),
    );
  });
}

Widget categoryCard(BuildContext context, int index, WidgetRef ref,
    {required Category category,
    required bool isSelected,
    required ProductFilterModel productFilterModel}) {
  return GestureDetector(
    onTap: () {
      if (index == ref.read(selectedCategoryByIndex)) {
        ref.refresh(selectedCategoryByIndex.notifier).state;
        productFilterModel = productFilterModel.copyWith(categoryId: null);
      } else {
        ref.read(selectedCategoryByIndex.notifier).state = index;
        productFilterModel =
            productFilterModel.copyWith(categoryId: category.id);
        onPressFilter(context, ref,
            productFilterModel: productFilterModel, shouldPop: false);
      }
    },
    child: Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      margin: EdgeInsets.only(right: 8.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? colors(context).primaryColor?.withValues(alpha: 0.1)
            : GlobalFunction.getContainerColor(),
        borderRadius: BorderRadius.circular(6.r),
        border: isSelected
            ? Border.all(color: colors(context).primaryColor!, width: 1.w)
            : null,
      ),
      child: Text(
        category.name,
        style: AppTextStyle(context).title.copyWith(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color:
                isSelected ? colors(context).primaryColor : Color(0xFF687387)),
      ),
    ),
  );
}
