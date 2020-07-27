import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  final TagInfo tagInfo;
  final InitData initData;
  final bool isFirstPage;
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
    return Text("result");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (tagInfo == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10,left: 10),
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
            child: makeTagList(context),
          )
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                color: Colors.blue,
                child: Text(
                  "${S.of(context).title_search_all}  >>",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (isFirstPage) {
                    showSearch(
                        context: context,
                        delegate: SearchPage(null, initData, false));
                  } else {
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      );
    }
  }

  Widget makeTagList(BuildContext context) {
    var tags = Api.getTagsWithCache();
    List<Widget> children = [];
    tags.tags.forEach((id, t) {
      Color backgroundColor = HexColor.fromHex(t.color);
      Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
      List<Widget> childCards = [];
      if (t.children != null) {
        t.children.forEach((id, t) {
          Color backgroundColor = HexColor.fromHex(t.color);
          Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
          childCards.add(Card(
            color: backgroundColor,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                t.name,
                style: TextStyle(color: textColor),
              ),
            ),
          ));
        });
      }
      children.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              color: backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  t.name,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
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
}
