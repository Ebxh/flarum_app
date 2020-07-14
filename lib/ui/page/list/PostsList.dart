import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/api/decoder/users.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/html/html.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets.dart';

class PostsList extends StatefulWidget {
  final InitData initData;
  final DiscussionInfo discussionInfo;

  PostsList(this.initData, this.discussionInfo);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  DiscussionInfo discussionInfo;
  int count = 0;

  bool isLoading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return discussionInfo != null
        ? Center(
            child: Stack(
              children: <Widget>[
                Center(
                  child: NotificationListener<ScrollNotification>(
                    child: ListView.builder(
                        itemCount: count + 1,
                        itemBuilder: (BuildContext context, int index) {
                          index = index - 1;
                          if (index == -1) {
                            Color backGroundColor;
                            if (widget.discussionInfo.tags == null ||
                                widget.discussionInfo.tags.length == 0) {
                              backGroundColor = Theme.of(context).primaryColor;
                            } else {
                              for (var t in widget.discussionInfo.tags) {
                                if (!t.isChild) {
                                  backGroundColor = backGroundColor =
                                      HexColor.fromHex(t.color);
                                  break;
                                }
                              }
                              if (backGroundColor == null) {
                                backGroundColor =
                                    Theme.of(context).primaryColor;
                              }
                            }
                            Color textColor = ColorUtil.getTitleFormBackGround(
                                backGroundColor);
                            return Container(
                              height: 120,
                              color: backGroundColor,
                              child: Center(
                                child: ListTile(
                                  title: Text(
                                    discussionInfo.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: textColor, fontSize: 20),
                                  ),
                                  subtitle: SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: makeMiniCards(
                                          context,
                                          widget.discussionInfo.tags,
                                          widget.initData),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          var card;
                          var p = discussionInfo
                              .posts[discussionInfo.postsIdList[index]];
                          if (p == null) {
                            print(index);
                            print(discussionInfo.postsIdList[index]);
                          }
                          switch (p.contentType) {
                            case "comment":
                              UserInfo u;
                              if (p.user == null) {
                                u = UserInfo.deletedUser;
                              } else {
                                u = discussionInfo.users[p.user];
                              }
                              if (u == null) {
                                print("${p.user} ${p.id} $count");
                              }
                              card = Card(
                                  elevation: 0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(u.displayName),
                                        leading: Avatar(
                                            u,
                                            Theme.of(context).primaryColor),
                                        subtitle: Text(p.createdAt),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, bottom: 15),
                                        child: HtmlView(
                                          p.contentHtml,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 40,
                                                  bottom: 10,
                                                  right: 40),
                                              child: IconButton(
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.thumbsUp,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {}),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 40,
                                                  bottom: 10,
                                                  right: 40),
                                              child: IconButton(
                                                  icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .commentAlt,
                                                      size: 18),
                                                  onPressed: () {}),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 40,
                                                  bottom: 10,
                                                  right: 40),
                                              child: IconButton(
                                                  icon: FaIcon(Icons.more_horiz,
                                                      size: 18),
                                                  onPressed: () {}),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ));
                              break;
                            case "discussionStickied":
                              var sticky =
                                  p.source["attributes"]["content"]["sticky"];
                              UserInfo u = discussionInfo.users[int.parse(
                                  p.source["relationships"]["user"]["data"]
                                      ["id"])];
                              Color textColor =
                                  Color.fromARGB(255, 209, 62, 50);
                              card = makeMessageCard(
                                  textColor,
                                  FontAwesomeIcons.thumbtack,
                                  u.displayName,
                                  sticky
                                      ? S.of(context).c_stickied_the_discussion
                                      : S
                                          .of(context)
                                          .c_unstickied_the_discussion);
                              break;
                            case "discussionLocked":
                              var locked =
                                  p.source["attributes"]["content"]["locked"];
                              UserInfo u = discussionInfo.users[int.parse(
                                  p.source["relationships"]["user"]["data"]
                                      ["id"])];
                              Color textColor =
                                  Color.fromARGB(255, 136, 136, 136);
                              card = makeMessageCard(
                                  textColor,
                                  FontAwesomeIcons.lock,
                                  u.displayName,
                                  locked
                                      ? S.of(context).c_locked_the_discussion
                                      : S
                                          .of(context)
                                          .c_unlocked_the_discussion);
                              break;
                            case "discussionTagged":
                              List before =
                                  p.source["attributes"]["content"][0];
                              List after = p.source["attributes"]["content"][1];
                              UserInfo u = discussionInfo.users[int.parse(
                                  p.source["relationships"]["user"]["data"]
                                      ["id"])];
                              List<TagInfo> removed = [];
                              List<TagInfo> added = [];

                              before.forEach((id) {
                                if (!after.contains(id)) {
                                  removed.add(Api.getTag(id));
                                }
                              });
                              after.forEach((id) {
                                if (!before.contains(id)) {
                                  added.add(Api.getTag(id));
                                }
                              });

                              card = makeTaggedCard(
                                  context, u.displayName, added, removed);
                              break;
                            case "discussionRenamed":
                              UserInfo u = discussionInfo.users[int.parse(
                                  p.source["relationships"]["user"]["data"]
                                      ["id"])];
                              String before =
                                  p.source["attributes"]["content"][0];
                              String after =
                                  p.source["attributes"]["content"][1];
                              card = makeMessageCard(
                                  Color.fromARGB(255, 102, 136, 153),
                                  FontAwesomeIcons.pen,
                                  u.displayName,
                                  "${S.of(context).c_change_the_title_form} `$before` ${S.of(context).c_change_the_title_to} `$after`");
                              break;
                            default:
                              print("UnimplementedTypes:" + p.contentType);
                              card = Card(
                                child:
                                    Text("UnimplementedTypes:" + p.contentType),
                              );
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 6),
                            child: card,
                          );
                        }),
                    onNotification: (ScrollNotification notification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                        if (!isLoading) {
                          loadMore();
                        }
                      }
                      return false;
                    },
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: SizedBox(
                      height: 3,
                      child: isLoading
                          ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                              backgroundColor: Colors.white54,
                            )
                          : SizedBox(),
                    ))
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget makeMessageCard(
      Color textColor, IconData icon, String userName, String text) {
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
      child: RichText(
          text: TextSpan(children: [
        WidgetSpan(
            child: FaIcon(
          icon,
          color: textColor,
          size: 18,
        )),
        WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 10))),
        WidgetSpan(
            child: InkWell(
          child: Text(
            userName,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textColor, fontSize: 18),
          ),
          onTap: () {},
        )),
        TextSpan(
          text: " ",
          style: TextStyle(fontSize: 18),
        ),
        TextSpan(
          text: text,
          style: TextStyle(fontSize: 18, color: textColor),
        )
      ])),
    ));
  }

  Widget makeTaggedCard(BuildContext context, String userName,
      List<TagInfo> added, List<TagInfo> removed) {
    Color textColor = Color.fromARGB(255, 102, 125, 153);
    InlineSpan centerWidget = WidgetSpan(child: SizedBox());
    if (added.length != 0 && removed.length != 0) {
      centerWidget = TextSpan(
          text: S.of(context).c_tag_and,
          style: TextStyle(color: textColor, fontSize: 18));
    }
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
        child: RichText(
            text: TextSpan(children: [
          WidgetSpan(
              child: FaIcon(
            FontAwesomeIcons.tag,
            color: textColor,
            size: 18,
          )),
          WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 10))),
          WidgetSpan(
              child: InkWell(
            child: Text(
              userName,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: textColor, fontSize: 18),
            ),
            onTap: () {},
          )),
          TextSpan(
            text: " ",
            style: TextStyle(fontSize: 18),
          ),
          added.length != 0
              ? TextSpan(
                  text: S.of(context).c_tag_added,
                  style: TextStyle(color: textColor, fontSize: 18))
              : WidgetSpan(child: SizedBox()),
          WidgetSpan(child: makeMiniTagCards(context, added, widget.initData)),
          TextSpan(
            text: " ",
            style: TextStyle(fontSize: 18),
          ),
          centerWidget,
          TextSpan(
            text: " ",
            style: TextStyle(fontSize: 18),
          ),
          removed.length != 0
              ? TextSpan(
                  text: S.of(context).c_tag_removed,
                  style: TextStyle(color: textColor, fontSize: 18))
              : WidgetSpan(child: SizedBox()),
          WidgetSpan(
              child: makeMiniTagCards(context, removed, widget.initData)),
        ])),
      ),
    );
  }

  Widget makeMiniTagCards(
      BuildContext context, List<TagInfo> tags, InitData initData) {
    List<Widget> cards = [];
    tags.forEach((t) {
      Color backGroundColor = HexColor.fromHex(t.color);
      Color textColor = ColorUtil.getTitleFormBackGround(backGroundColor);
      cards.add(Padding(
        padding: EdgeInsets.only(left: 5),
        child: Container(
          color: backGroundColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 2, right: 2),
              child: Text(
                t.name,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ));
    });
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: cards,
      ),
    );
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    var d = await Api.getDiscussion(widget.discussionInfo.id);
    setState(() {
      isLoading = false;
      if (d.posts.length >= 20) {
        count = 20;
      } else {
        count = d.posts.length;
      }
      discussionInfo = d;
    });
  }

  loadMore() async {
    int c = 0;
    if (count == discussionInfo.postsIdList.length) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });
      if (count + 20 > discussionInfo.postsIdList.length) {
        c = count + (discussionInfo.postsIdList.length - count);
      } else {
        c = count + 20;
      }
      List<int> nl = [];
      for (int i = count; i < c; i++) {
        var p = discussionInfo.posts[i];
        if (p == null) {
          nl.add(discussionInfo.postsIdList[i]);
        }
      }

      var posts = await Api.getPostsById(nl);
      discussionInfo.posts.addAll(posts.posts);
      discussionInfo.users.addAll(posts.users);
      isLoading = false;
      setState(() {
        count = c;
      });
    }
  }
}
