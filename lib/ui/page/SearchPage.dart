import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/page/list/DiscussionsList.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

typedef Function OnTagSelected(TagInfo tagInfo);

class SearchPage extends SearchDelegate<String> {
  TagInfo tagInfo;
  InitData initData;
  bool isFirstPage;
  Discussions result;
  String lastQuery = "";
  SearchPage(
    this.tagInfo,
    this.initData,
    this.isFirstPage, {
    String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(primaryColor: Colors.white, brightness: Brightness.light);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear_all),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (lastQuery != "${tagInfo == null ? "" : tagInfo.slug}:$query") {
      result = null;
      lastQuery = "${tagInfo == null ? "" : tagInfo.slug}:$query";
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      if (result == null) {
        Api.searchDiscuss(query, tagInfo == null ? "" : tagInfo.slug).then((r) {
          setState.call(() {
            result = r;
          });
        });
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListPage(
            InitData(
                initData.forumInfo, initData.tags, result, initData.loggedUser),
            Theme.of(context).primaryColor);
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      int index = tagInfo == null ? 0 : 1;
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: IndexedStack(
            key: Key(index.toString()),
            index: index,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "${S.of(context).title_search_with_tag} :",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: makeTagList(context, (TagInfo t) {
                        setState.call(() {
                          tagInfo = t;
                        });
                        return;
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "<< ${S.of(context).title_search_all}",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState.call(() {
                            tagInfo = null;
                          });
                        })
                  ],
                ),
              )
            ],
          ));
    });
  }

  Widget makeTagList(BuildContext context, OnTagSelected onTagSelected) {
    var tags = Api.getTagsWithCache();
    List<Widget> children = [];
    tags.tags.forEach((id, t) {
      List<Widget> childCards = [];
      if (t.children != null) {
        t.children.forEach((id, t) {
          childCards.add(
            makeTagCard(context, t, onTagSelected),
          );
        });
      }
      children.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            makeTagCard(context, t, onTagSelected),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: childCards,
            )
          ],
        ),
      ));
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  makeTagCard(BuildContext context, TagInfo t, OnTagSelected onTagSelected) {
    Color backgroundColor = HexColor.fromHex(t.color);
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
    return InkWell(
      child: Card(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            t.name,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
      onTap: () {
        onTagSelected(t);
      },
    );
  }
}
