import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:flutter/material.dart';

import '../../widgets.dart';

class HomePage extends StatefulWidget {
  final InitData initData;

  HomePage(this.initData);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
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
        : NotificationListener<ScrollNotification>(
            child: Scrollbar(
                child: RefreshIndicator(
                    child: ListView.builder(
                        itemCount: end
                            ? widget.initData.discussions.list.length + 1
                            : widget.initData.discussions.list.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (end &&
                              index ==
                                  widget.initData.discussions.list.length) {
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
                              title: Text(d.title), leading: Avatar(d.user));
                        }),
                    onRefresh: () async {
                      widget.initData.discussions =
                          await Api.getDiscussionsByUrl(
                              widget.initData.discussions.links.first);
                      setState(() {});
                      return;
                    })),
            onNotification: (ScrollNotification notification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                if (!isLoading) {
                  loadMore(context, widget.initData);
                }
              }
              return false;
            },
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
