import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/controllers/misc/misc_controller.dart';
import 'package:ready_grocery/views/eCommerce/dashboard/layouts/dashboard_layout.dart';

class AppBottomNavbar extends ConsumerWidget {
  const AppBottomNavbar({
    super.key,
    required this.bottomItem,
    required this.onSelect,
  });
  final List<BottomItem> bottomItem;
  final Function(int? index) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InnerShadow(
      shadows: [
        Shadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(2, 5)),
        Shadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(-2, -5))
      ],
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 72.h,
        margin: EdgeInsets.all(16.r)
            .copyWith(bottom: 14.h, left: 16.w, right: 16.w),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: EcommerceAppColor.primaryDark),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              bottomItem.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    onSelect(index);
                  },
                  child: _buildBottomItem(
                    bottomItem: bottomItem[index],
                    index: index,
                    context: context,
                    ref: ref,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required BottomItem bottomItem,
    required int index,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final int selectedIndex = ref.watch(selectedTabIndexProvider);

    final isSelected = index == selectedIndex;

    return InnerShadow(
      shadows: [
        Shadow(
            color: Colors.grey.withValues(alpha: 0.24),
            blurRadius: 4,
            offset: Offset(1, 4)),
        Shadow(
            color: Colors.grey.withValues(alpha: 0.24),
            blurRadius: 4,
            offset: Offset(-1, -4))
      ],
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
            color: isSelected ? Color(0xFF51AF5B) : null,
            shape: BoxShape.circle),
        child: Center(
          child: SvgPicture.asset(
            colorFilter:
                ColorFilter.mode(EcommerceAppColor.white, BlendMode.srcIn),
            isSelected ? bottomItem.activeIcon : bottomItem.icon,
            height: 24.w,
            width: 24.w,
          ),
        ),
      ),
    );
  }
}
