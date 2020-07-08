import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/ui/html/html.dart';
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

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return discussionInfo != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Center(
                child: ListView.builder(
                    itemCount: count,
                    itemBuilder: (BuildContext context, int index) {
                      var card;
                      var p = discussionInfo
                          .posts[discussionInfo.postsIdList[index]];
                      switch (p.contentType) {
                        case "comment":
                          card = Card(
                              elevation: 0.1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(discussionInfo
                                        .users[p.user].displayName),
                                    leading: Avatar(
                                        discussionInfo.users[p.user],
                                        Theme.of(context).primaryColor),
                                    subtitle: Text(p.createdAt),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, bottom: 15),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: HtmlView(
                                        p.contentHtml,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 40, bottom: 10, right: 40),
                                          child: IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.thumbsUp),
                                              onPressed: () {}),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 40, bottom: 10, right: 40),
                                          child: IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.commentAlt),
                                              onPressed: () {}),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 40, bottom: 10, right: 40),
                                          child: IconButton(
                                              icon: FaIcon(Icons.more_horiz),
                                              onPressed: () {}),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                          break;
                        default:
                          card = Card(
                            child: Text("UnimplementedTypes:" + p.contentType),
                          );
                      }
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: card,
                        );
                      }
                      return card;
                    }),
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  loadData() async {
    var d = await Api.getDiscussion(widget.discussionInfo.id);
    setState(() {
      if (d.posts.length >= 20) {
        count = 20;
      } else {
        count = d.posts.length;
      }
      discussionInfo = d;
    });
  }
}
