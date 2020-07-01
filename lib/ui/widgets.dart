import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/api/decoder/users.dart';
import 'package:core/conf/app.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/util/String.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

import 'page/TagPage.dart';

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
  final Color backgroundColor;

  Avatar(this.user,this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    if (user.avatarUrl == "") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Container(
          height: 48,
          width: 48,
          color: Colors.grey,
        ),
      );
    }
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
                  color: backgroundColor,
                  child: Center(
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )),
    );
  }
}

Widget makeMiniCards(
    BuildContext context, List<TagInfo> tags, InitData initData) {
  if (tags.length == 0) {
    return null;
  }
  return NotificationListener<ScrollNotification>(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: tags
              .map((t) => SizedBox(
                    height: 32,
                    child: InkWell(
                      child: Card(
                        color: HexColor.fromHex(t.color),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: Text(
                              t.name,
                              style: TextStyle(
                                fontSize: 12,
                                  color: TextColor.getTitleFormBackGround(
                                      HexColor.fromHex(t.color))),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        var tag;
                        if (t.isChild) {
                          tag = t;
                        } else if (t.position != null) {
                          tag = Api.getTag(t.id);
                        } else {
                          tag = initData.tags.miniTags[t.id];
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TagInfoPage(tag, initData);
                        }));
                      },
                    ),
                  ))
              .toList()),
    ),
    onNotification: (ScrollNotification notification) {
      return true;
    },
  );
}

Widget makeSortPopupMenu(BuildContext context, String discussionSort,Color textColor,
    PopupMenuItemSelected<String> onSelected) {
  return SizedBox(
    height: 24,
    width: 10,
    child: PopupMenuButton<String>(
      tooltip: S.of(context).title_sort,
      child: Text(
        AppConfig.getDiscussionSortInfo(context)[discussionSort],
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor),
      ),
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem<String>> list = [];
        AppConfig.getDiscussionSortInfo(context).forEach((key, value) {
          if (key != discussionSort) {
            list.add(PopupMenuItem(
              child: Text(value),
              value: key,
            ));
          }
        });
        return list;
      },
      onSelected: onSelected,
    ),
  );
}
