import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/tags.dart';
import 'file:///C:/Users/me/AndroidStudioProjects/flarum_app/lib/ui/page/list/DiscussionsList.dart';
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
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
    Color subTextColor = ColorUtil.getSubtitleFormBackGround(backgroundColor);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                forceElevated: true,
                backgroundColor: backgroundColor,
                centerTitle: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 100,
                        left: 10,
                        right: 10,
                      ),
                      child: SizedBox(
                        height: 200,
                        child: ListTile(
                          title: Text(
                            widget.tagInfo.name,
                            style: TextStyle(color: textColor, fontSize: 26),
                          ),
                          subtitle: Text(
                            widget.tagInfo.description,
                            maxLines: 3,
                            style: TextStyle(color: subTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: SizedBox(
                    height: 48,
                    child: ListTile(
                        title: Text(
                          innerBoxIsScrolled ? widget.tagInfo.name : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textColor, fontSize: 20),
                        ),
                        subtitle: _sortPopupMenu(context, subTextColor)),
                  ),
                  centerTitle: true,
                ),
                leading: makeBackButton(context, textColor),
                actions: <Widget>[
                  widget.tagInfo.isChild ||
                          widget.tagInfo.children == null ||
                          widget.tagInfo.children.length == 0
                      ? SizedBox(
                          height: 48,
                          width: 48,
                        )
                      : PopupMenuButton(
                          child: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: textColor,
                              ),
                              onPressed: null),
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
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return TagInfoPage(tag, initData);
                            }));
                          },
                        )
                ],
              )
            ];
          },
          body: ListPage(
            initData,
            backgroundColor,
          )),
    );
  }

  Widget _sortPopupMenu(BuildContext context, Color subTextColor) {
    return makeSortPopupMenu(context, discussionSort, subTextColor,
        (key) async {
      setState(() {
        discussionSort = key;
        initData.discussions = null;
      });
      loadData();
    });
  }

  loadData() async {
    var d = await Api.getDiscussionList(discussionSort,
        tagSlug: widget.tagInfo.slug);
    if (d != null) {
      setState(() {
        initData.discussions = d;
      });
    }
  }
}
