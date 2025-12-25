import 'package:flutter/material.dart';

import '../config/theme.dart';

Color? getOpacityPrimaryColor(BuildContext context, {double opacity = 0.1}) {
  return colors(context).primaryColor?.withValues(alpha: opacity);
}
