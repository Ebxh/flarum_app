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
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        brightness: Brightness.light,
        title: Text(
          S.of(context).title_discussion_detail,
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
        leading: makeBackButton(context, textColor),
      ),
      backgroundColor: Color.fromARGB(255, 242, 241, 246),
      body: PostsList(widget.initData, widget.discussionInfo),
    );
  }
}
