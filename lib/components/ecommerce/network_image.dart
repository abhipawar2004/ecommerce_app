import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ready_grocery/utils/is_dark_mode.dart';
import 'package:shimmer/shimmer.dart';

Widget networkImage(String? url, {double? width, double? height, BoxFit? fit}) {
  if (url == null) return SizedBox.shrink();
  final isDark = isDarkMode();
  final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
  final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: fit,
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        color: baseColor,
      ),
    ),
    errorWidget: (context, url, error) => Icon(
      Icons.error,
      color: Colors.red,
    ),
  );
}
