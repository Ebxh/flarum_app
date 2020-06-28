import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/api/decoder/users.dart';
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

class Avatar extends StatelessWidget {
  final UserInfo user;

  Avatar(this.user);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: user.avatarUrl != null
              ? CachedNetworkImage(
            imageUrl: user.avatarUrl,
          )
              : Container(
            height: 48,
            width: 48,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                user.username[0].toUpperCase(),
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          )),
    );
  }
}
