import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

Widget productLoader(BuildContext context, {bool isGrid = false}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: isGrid
        ? GridView.builder(
            shrinkWrap: true,
            // padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8, // Adjust this ratio as needed
            ),
            itemBuilder: (_, __) => gridProductCard(),
            itemCount: 6, // Even number for grid
          )
        : ListView.separated(
            shrinkWrap: true,
            // padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (_, __) => listProductCard(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: 5,
          ),
  );
}

// List layout card (your original design)
Widget listProductCard() {
  return Row(
    children: [
      Container(
        height: 100,
        width: 100,
        color: Colors.white,
      ),
      Gap(8.w),
      Expanded(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 5),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                width: 100,
                color: Colors.black,
              ),
              Gap(8.h),
              Container(
                height: 10,
                width: 80,
                color: Colors.black,
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

// Grid layout card
Widget gridProductCard() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image placeholder
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        // Product details
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product title
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Colors.black,
                ),
                Gap(6.h),
                // Product subtitle/price
                Container(
                  height: 8,
                  width: 80,
                  color: Colors.black,
                ),
                Spacer(),
                // Add to cart button area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 8,
                      width: 40,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
