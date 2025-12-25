import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ready_grocery/components/ecommerce/app_bar.dart';
import 'package:ready_grocery/config/theme.dart';

Widget zoomAbleImageView(BuildContext context, String? url,
    {bool networkImage = true, Color? backgroundColor}) {
  if (url == null) return SizedBox.shrink();
  return PhotoView(
    backgroundDecoration: BoxDecoration(
      color: backgroundColor ?? colors(context).accentColor,
    ),
    imageProvider:
        networkImage ? CachedNetworkImageProvider(url) : AssetImage(url),
  );
}

class ZoomAbleImageView extends StatelessWidget {
  const ZoomAbleImageView({super.key, this.url, this.networkImage = true});
  final String? url;
  final bool networkImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppbar(context),
      body: zoomAbleImageView(context, url),
    );
  }
}
