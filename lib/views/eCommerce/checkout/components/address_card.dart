import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_grocery/config/app_color.dart';
import 'package:ready_grocery/config/app_constants.dart';
import 'package:ready_grocery/config/app_text_style.dart';
import 'package:ready_grocery/config/theme.dart';
import 'package:ready_grocery/gen/assets.gen.dart';
import 'package:ready_grocery/generated/l10n.dart';
import 'package:ready_grocery/models/eCommerce/address/add_address.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';

class AddressCard extends StatelessWidget {
  final AddAddress? address;
  final bool showEditButton;
  final void Function()? onTap;
  final void Function()? editTap;

  final Color? cardColor;
  final Color? borderColor;
  const AddressCard(
      {super.key,
      required this.address,
      this.showEditButton = false,
      this.onTap,
      this.editTap,
      this.cardColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppConstants.appSettingsBox).listenable(),
        builder: (context, box, _) {
          final appLocal = box.get(AppConstants.appLocal);
          return Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: onTap,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.symmetric(vertical: 14.h).copyWith(
                      left: 40.w, right: appLocal == 'ar' ? 40.w : null),
                  // margin: EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: cardColor ??
                        colors(context).primaryColor?.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                          color: borderColor ??
                              colors(context)
                                  .primaryColor!
                                  .withValues(alpha: 0.2),
                          width: 2),
                    ),
                    // shadows: [
                    //   BoxShadow(
                    //     color: colors(context).primaryColor!.withValues(alpha: 0.1),
                    //     blurRadius: 2,
                    //     offset: Offset(2, 5),
                    //     spreadRadius: 2,
                    //     blurStyle: BlurStyle.inner
                    //   ),
                    //   BoxShadow(
                    //     color: colors(context).primaryColor!.withValues(alpha: 0.1),
                    //     blurRadius: 2,
                    //     offset: Offset(-2, -5),
                    //     spreadRadius: 2,
                    //     blurStyle: BlurStyle.inner
                    //   )
                    // ]
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddressTagCard(context: context),
                      Gap(10.h),
                      _buildAddressInfoWidget(context: context),
                    ],
                  ),
                ),
              ),
              if (showEditButton)
                Positioned(
                  right: appLocal == 'ar' ? null : 14.w,
                  top: 12.h,
                  left: appLocal == 'ar' ? 14.w : null,
                  child: _buildEditButton(context: context),
                ),
              Positioned(
                top: 16.h,
                left: appLocal == 'ar' ? null : 14.w,
                right: appLocal == 'ar' ? 16.w : null,
                child: SvgPicture.asset(
                  Assets.svg.locationPurple,
                  colorFilter: ColorFilter.mode(
                      colors(context).primaryColor!, BlendMode.srcIn),
                ),
              )
            ],
          );
        });
  }

  Widget _buildAddressTagCard({required BuildContext context}) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: ShapeDecoration(
              color: isDarkMode() ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            child: Text(
              address!.addressType.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontFamily: 'Mulish',
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        if (address!.isDefault) ...[
          Gap(8.w),
          Flexible(
            child: Text(
              S.of(context).defaultAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          )
        ]
      ],
    );
  }

  Widget _buildEditButton({required BuildContext context}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: editTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
            side: BorderSide(color: EcommerceAppColor.primary),
          ),
        ),
        child: Center(
          child: Text(
            S.of(context).edit,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(color: EcommerceAppColor.primary, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressInfoWidget({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address!.name,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle(context).bodyTextSmall.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode() ? Colors.white : Colors.black),
        ),
        Gap(5.h),
        Text(
          address!.phone,
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
        ),
        Gap(5.h),
        Text(
          [
            address?.addressLine,
            address?.flatNo,
            address?.addressLine2,
            address?.area,
            address?.postCode != null ? "-${address!.postCode}" : null
          ]
              .where((element) => element != null && element.isNotEmpty)
              .join(", "),
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
