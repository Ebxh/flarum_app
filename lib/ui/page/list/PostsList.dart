import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/api/decoder/users.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/html/html.dart';
import 'package:core/util/color.dart';
import 'package:flutter/cupertino.dart';
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
                    child: RefreshIndicator(
                        child: ListView.builder(
                            itemCount: count + 1,
                            itemBuilder: (BuildContext context, int index) {
                              index = index - 1;
                              if (index == -1) {
                                Color backGroundColor;
                                if (widget.discussionInfo.tags == null ||
                                    widget.discussionInfo.tags.length == 0) {
                                  backGroundColor =
                                      Theme.of(context).primaryColor;
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
                                Color textColor =
                                    ColorUtil.getTitleFormBackGround(
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
                                print(
                                    "null discussionInfo(index:$index,id:${discussionInfo.postsIdList[index]}),on url：");
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

                                  var buttonPadding =
                                      MediaQuery.of(context).size.width / 12;

                                  card = Card(
                                      elevation: 0,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(u.displayName),
                                            leading: Avatar(
                                                u,
                                                Theme.of(context).primaryColor,
                                                UniqueKey()),
                                            subtitle: Text(p.createdAt),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                bottom: 15),
                                            child: HtmlView(
                                              p.contentHtml,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: buttonPadding,
                                                      bottom: 10,
                                                      right: buttonPadding),
                                                  child: IconButton(
                                                      icon: FaIcon(
                                                        FontAwesomeIcons
                                                            .thumbsUp,
                                                        size: 18,
                                                      ),
                                                      onPressed: () {}),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: buttonPadding,
                                                      bottom: 10,
                                                      right: buttonPadding),
                                                  child: IconButton(
                                                      icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .commentAlt,
                                                          size: 18),
                                                      onPressed: () {}),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: buttonPadding,
                                                      bottom: 10,
                                                      right: buttonPadding),
                                                  child: IconButton(
                                                      icon: FaIcon(
                                                          Icons.more_horiz,
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
                                  var sticky = p.source["attributes"]["content"]
                                      ["sticky"];
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
                                          ? S
                                              .of(context)
                                              .c_stickied_the_discussion
                                          : S
                                              .of(context)
                                              .c_unstickied_the_discussion);
                                  break;
                                case "discussionLocked":
                                  var locked = p.source["attributes"]["content"]
                                      ["locked"];
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
                                          ? S
                                              .of(context)
                                              .c_locked_the_discussion
                                          : S
                                              .of(context)
                                              .c_unlocked_the_discussion);
                                  break;
                                case "discussionTagged":
                                  List before =
                                      p.source["attributes"]["content"][0];
                                  List after =
                                      p.source["attributes"]["content"][1];
                                  UserInfo u = discussionInfo.users[int.parse(
                                      p.source["relationships"]["user"]["data"]
                                          ["id"])];
                                  List<TagInfo> beforeTags = [];
                                  List<TagInfo> afterTags = [];

                                  before.forEach((id) {
                                    beforeTags.add(Api.getTagById(id));
                                  });
                                  after.forEach((id) {
                                    afterTags.add(Api.getTagById(id));
                                  });
                                  Color textColor =
                                      Color.fromARGB(255, 102, 125, 153);
                                  card = makeMessageCard(
                                      textColor,
                                      FontAwesomeIcons.tag,
                                      u.displayName,
                                      S.of(context).c_change_the_tag,
                                      details: makeBeforeAndAfterWidget(
                                          context,
                                          makeMiniCards(context, beforeTags,
                                              widget.initData),
                                          makeMiniCards(context, afterTags,
                                              widget.initData)));
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
                                      "${S.of(context).c_change_the_title}",
                                      details: makeBeforeAndAfterWidget(
                                          context, Text(before), Text(after)));
                                  break;
                                default:
                                  print("UnimplementedTypes:" + p.contentType);
                                  card = Card(
                                    child: Text(
                                        "UnimplementedTypes:" + p.contentType),
                                  );
                              }
                              return Padding(
                                padding:
                                    EdgeInsets.only(left: 8, right: 8, top: 6),
                                child: card,
                              );
                            }),
                        onRefresh: () {
                          return loadData();
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
      Color textColor, IconData icon, String userName, String text,
      {Widget details}) {
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
        ),
        details == null
            ? TextSpan()
            : WidgetSpan(
                child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: InkWell(
                  child: Text(
                    S.of(context).title_show_details,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: Builder(builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(S.of(context).title_details),
                            content: details,
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(S.of(context).title_close),
                              )
                            ],
                          );
                        }));
                  },
                ),
              )),
      ])),
    ));
  }

  Widget makeBeforeAndAfterWidget(
      BuildContext context, Widget before, Widget after) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            "${S.of(context).title_change_before} :",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: before,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            "${S.of(context).title_change_after} :",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: after,
        ),
      ],
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
        print(discussionInfo.postsIdList.length - count);
      } else {
        c = count + 20;
      }
      List<int> nl = [];
      for (int i = count; i < c; i++) {
        nl.add(discussionInfo.postsIdList[i]);
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
