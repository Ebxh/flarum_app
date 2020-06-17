import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/util/String.dart';
import 'package:flutter/material.dart';

class SiteIcon extends StatelessWidget {
  final ForumInfo info;

  SiteIcon(this.info);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (info.logoUrl == null ||
        info.logoUrl == "" ||
        !StringCheck(info.logoUrl).isUrl()) {
      widget = SizedBox();
    } else {
      widget = CachedNetworkImage(imageUrl: info.logoUrl);
    }
    return widget;
  }
}
