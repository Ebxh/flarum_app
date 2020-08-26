import 'package:core/api/data.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/page/list/PostsList.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class DiscussionPage extends StatefulWidget {
  final InitData initData;
  final DiscussionInfo discussionInfo;

  DiscussionPage(this.initData, this.discussionInfo);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  String readProgress = "0/0";

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        brightness: Brightness.light,
        title: ListTile(
          title: Text(
            S.of(context).title_discussion_detail,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            readProgress,
            textAlign: TextAlign.center,
          ),
        ),
        leading: makeBackButton(context, textColor),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.keyboard_arrow_down,color: textColor,),
            itemBuilder: (BuildContext context) {
              return [];
            },
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 242, 241, 246),
      body: PostsList(
        widget.initData,
        widget.discussionInfo,
        onReadReadingProgressChange: (int current, int total) {
          setState(() {
            readProgress = "$current/$total";
          });
        },
      ),
    );
  }
}
