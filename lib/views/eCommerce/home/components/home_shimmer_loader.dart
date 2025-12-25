import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerLoader extends StatelessWidget {
  const HomeShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Horizontal Product List
            sectionTitle(),
            SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, __) => productCard(),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: 5,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Image Slider
            imageSlider(),

            const SizedBox(height: 20),

            // 🔹 Flash Sale Banner
            flashSaleBanner(),

            const SizedBox(height: 20),

            // 🔹 Popular Products Horizontal List
            sectionTitle(),
            SizedBox(
              height: 180,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, __) => bigProductCard(),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: 5,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 🔹 Section Title Loader
Widget sectionTitle() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Container(
      width: 120,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}

// 🔹 Small Product Card Loader
Widget productCard() {
  return Column(
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: 80,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ],
  );
}

// 🔹 Big Product Card Loader
Widget bigProductCard() {
  return Column(
    children: [
      Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      const SizedBox(width: 10),
      Container(
        width: 100,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ],
  );
}

// 🔹 Image Slider Loader
Widget imageSlider() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    height: 160,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

// 🔹 Flash Sale Banner Loader
Widget flashSaleBanner() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
