import 'package:core/api/data.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/util/HexColor.dart';
import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {
  final InitData initData;

  TagsPage(this.initData);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.initData.tags.tags.length,
        itemBuilder: (BuildContext context, int index) {
          return makeTagCard(widget.initData.tags.tags[index], context);
        });
  }

  Widget makeTagCard(TagInfo tag, BuildContext context) {
    var backgroundColor = HexColor.fromHex(tag.color);
    var titleColor =
        backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    List<Widget> children = [];
    tag.children.forEach((key, t) {
      children.add(SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Card(
            elevation: 0,
            color: Colors.white60,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Padding(
              padding: EdgeInsets.only(left: 30, top: 8, bottom: 8),
              child: Text(
                t.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ));
    });
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Card(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                tag.name,
                style: TextStyle(color: titleColor, fontSize: 24),
              ),
            ),
            Padding(
              padding: children.length != 0
                  ? EdgeInsets.only(bottom: 10)
                  : EdgeInsets.all(0),
              child: Column(children: children),
            )
          ],
        ),
      ),
    );
  }
}
