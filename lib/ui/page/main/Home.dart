import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/util/color.dart';
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
        : Scrollbar(
            child: RefreshIndicator(
                child: NotificationListener<ScrollNotification>(
                  child: ListView.builder(
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
                          leading: Avatar(d.user),
                          subtitle: makeMiniCards(context, d.tags),
                        );
                      }),
                  onNotification: (ScrollNotification notification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      print("down");
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

  Widget makeMiniCards(BuildContext context, List<TagInfo> tags) {
    if (tags.length == 0) {
      return null;
    }
    return NotificationListener<ScrollNotification>(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: tags
                .map((t) => SizedBox(
                      height: 32,
                      child: Card(
                        color: HexColor.fromHex(t.color),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: Text(
                              t.name,
                              style: TextStyle(
                                  color: TextColor.getTitleFormBackGround(
                                      HexColor.fromHex(t.color))),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList()),
      ),
      onNotification: (ScrollNotification notification) {
        return true;
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
