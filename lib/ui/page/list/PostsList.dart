import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/ui/html/html.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return discussionInfo != null
        ? ListView.builder(
            itemCount: discussionInfo.postsIdList.length,
            itemBuilder: (BuildContext context, int index) {
              var p = discussionInfo.posts[discussionInfo.postsIdList[index]];
              if (p == null) {
                return Card(
                  child: Text("loading..."),
                );
              }
              switch (p.contentType) {
                case "comment":
                  return Card(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(discussionInfo.users[p.user].displayName),
                        leading: Avatar(discussionInfo.users[p.user],
                            Theme.of(context).primaryColor),
                        subtitle: Text(p.createdAt),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: HtmlView(p.contentHtml),
                      )
                    ],
                  ));
                  break;
                default:
                  return Card(
                    child: Text("UnimplementedTypes:" + p.contentType),
                  );
              }
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  loadData() async {
    var d = await Api.getDiscussion(widget.discussionInfo.id);
    setState(() {
      discussionInfo = d;
    });
  }
}
