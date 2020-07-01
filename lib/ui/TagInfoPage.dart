import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/ui/page/List.dart';
import 'package:core/ui/widgets.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

class TagInfoPage extends StatefulWidget {
  final TagInfo tagInfo;
  final InitData initData;

  TagInfoPage(this.tagInfo, this.initData);

  @override
  _TagInfoPageState createState() => _TagInfoPageState();
}

class _TagInfoPageState extends State<TagInfoPage> {
  String discussionSort = "";
  InitData initData;

  @override
  void initState() {
    initData = InitData(widget.initData.forumInfo, widget.initData.tags, null);
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = HexColor.fromHex(widget.tagInfo.color);
    Color textColor = TextColor.getTitleFormBackGround(backgroundColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: ListTile(
          title: Text(
            widget.tagInfo.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 20),
          ),
          subtitle: makeSortPopupMenu(context, discussionSort,TextColor.getSubtitleFormBackGround(backgroundColor), (key) async {
            setState(() {
              discussionSort = key;
              initData.discussions = null;
            });
            loadData();
          }),
        ),
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            color: textColor,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          widget.tagInfo.isChild ||
                  widget.tagInfo.children == null ||
                  widget.tagInfo.children.length == 0
              ? SizedBox(
                  height: 48,
                  width: 48,
                )
              : PopupMenuButton(
                  color: textColor,
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuItem<TagInfo>> list = [];
                    widget.tagInfo.children.forEach((_, tag) {
                      list.add(PopupMenuItem(
                        child: Text(tag.name),
                        value: tag,
                      ));
                    });
                    return list;
                  },
                  onSelected: (TagInfo tag) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TagInfoPage(tag, initData);
                    }));
                  },
                )
        ],
      ),
      body: ListPage(initData, backgroundColor),
    );
  }

  loadData() async {
    var d =
        await Api.getDiscussions(discussionSort, tagSlug: widget.tagInfo.slug);
    if (d != null) {
      setState(() {
        initData.discussions = d;
      });
    }
  }
}
