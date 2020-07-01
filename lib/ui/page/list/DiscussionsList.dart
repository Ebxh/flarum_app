import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
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
        : Scrollbar(
            child: RefreshIndicator(
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
                        return ListTile(
                          title: Text(d.title),
                          leading: Avatar(d.user,widget.backgroundColor),
                          trailing: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 30,
                                constraints: BoxConstraints(maxWidth: 50),
                                color: Colors.black12,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: Text("${d.commentCount - 1}"),
                                  ),
                                ),
                              )),
                          onTap: () {},
                          subtitle:
                              makeMiniCards(context, d.tags, widget.initData),
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
                  widget.initData.discussions = await Api.getDiscussionsByUrl(
                      widget.initData.discussions.links.first);
                  setState(() {});
                  return;
                }),
          );
  }

  loadMore(BuildContext context, InitData initData) async {
    if (initData.discussions.links.next != null) {
      isLoading = true;
      var result =
          await Api.getDiscussionsByUrl(initData.discussions.links.next);
      if (result != null) {
        setState(() {
          initData.discussions.list.addAll(result.list);
          initData.discussions.links = result.links;
        });
      }
      isLoading = false;
      setState(() {});
    }
  }
}
