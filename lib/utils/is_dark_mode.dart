import 'package:flutter/material.dart';
import 'package:ready_grocery/utils/global_function.dart';

bool isDarkMode() {
  final context = GlobalFunction.navigatorKey.currentContext;
  if (context == null) {
    return false;
  }
  return Theme.of(context).brightness == Brightness.dark;
}
