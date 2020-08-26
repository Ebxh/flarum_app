import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/ui/page/DiscussionPage.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

import '../../widgets.dart';

class ListPage extends StatefulWidget {
  final InitData initData;
  final Color backgroundColor;
  ListPage(this.initData, this.backgroundColor);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var end = false;
    if (widget.initData.discussions != null) {
      if (widget.initData.discussions.links.next == null) {
        end = true;
      }
    }
    return widget.initData.discussions == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            child: NotificationListener<ScrollNotification>(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  itemCount: end
                      ? widget.initData.discussions.list.length + 1
                      : widget.initData.discussions.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (end &&
                        index == widget.initData.discussions.list.length) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Text(
                          "----end----",
                          style: TextStyle(color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    var d = widget.initData.discussions.list[index];
                    int lastReadPostNumber = d.source["lastReadPostNumber"];
                    int unread = d.lastPostNumber;
                    Color numberBoxBackground = Colors.grey;
                    if (lastReadPostNumber == null && Api.isLogin()) {
                      lastReadPostNumber = 0;
                    }
                    if (lastReadPostNumber != null) {
                      unread = d.lastPostNumber - lastReadPostNumber;
                      if (unread == 0) {
                        lastReadPostNumber = null;
                        unread = d.commentCount -1;
                      }else {
                        numberBoxBackground = widget.backgroundColor;
                      }
                    }
                    return ListTile(
                      title: Text(
                        d.title,
                        style: TextStyle(
                            fontWeight: lastReadPostNumber == null
                                ? FontWeight.normal
                                : FontWeight.bold),
                      ),
                      leading: Avatar(d.user, widget.backgroundColor,
                          "${d.user.username}-$index"),
                      trailing: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 30,
                            constraints: BoxConstraints(maxWidth: 50),
                            color: numberBoxBackground,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Text("$unread",style: TextStyle(
                                  color: ColorUtil.getTitleFormBackGround(numberBoxBackground)
                                ),),
                              ),
                            ),
                          )),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return DiscussionPage(widget.initData, d);
                        }));
                      },
                      subtitle: makeMiniCards(context, d.tags, widget.initData),
                    );
                  }),
              onNotification: (ScrollNotification notification) {
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  if (!isLoading) {
                    loadMore(context, widget.initData);
                  }
                }
                return false;
              },
            ),
            onRefresh: () async {
              widget.initData.discussions = await Api.getDiscussionListByUrl(
                  widget.initData.discussions.links.first);
              setState(() {});
              return;
            });
  }

  loadMore(BuildContext context, InitData initData) async {
    if (initData.discussions.links.next != null) {
      isLoading = true;
      var result =
          await Api.getDiscussionListByUrl(initData.discussions.links.next);
      if (result != null) {
        setState(() {
          initData.discussions.list.addAll(result.list);
          initData.discussions.links = result.links;
        });
      } else {}
      isLoading = false;
      setState(() {});
    }
  }
}
