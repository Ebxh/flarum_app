import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class HtmlView extends StatelessWidget {
  final String content;

  HtmlView(this.content);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    parse(content).body.children.forEach((element) {
      widgets.add(getWidget(context, element));
    });
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets),
    );
  }

  Widget getWidget(BuildContext context, dom.Element element) {
    switch (element.localName) {
      case "p":
        if (element.children == null || element.children.length == 0) {
          return contentPadding(Text(
            element.text,
            style: TextStyle(fontSize: 18),
          ));
        } else {
          if (element.children.length == 1 &&
              element.children[0].localName == "img") {
            return getWidget(context, element.children[0]);
          } else {
            /// TODO RichText
            return contentPadding(Text(
              element.text,
              style: TextStyle(fontSize: 18),
            ));
          }
        }
        break;
      case "h1":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ));
      case "h2":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
      case "h3":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ));
      case "h4":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
      case "h5":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ));
      case "h6":
        return contentPadding(Text(
          element.text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ));
      case "hr":
        return contentPadding(Divider(
          height: 1,
          color: Colors.grey,
        ));
      case "br":
        return contentPadding(SizedBox());
      case "img":
        return contentPadding(Center(
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: element.attributes["src"],
              placeholder: (BuildContext context, String url) {
                return Icon(
                  Icons.image,
                  size: 64,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ));
      case "details":
        return contentPadding(SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                S.of(context).title_show_details,
                style: TextStyle(
                    color: ColorUtil.getTitleFormBackGround(
                        Theme.of(context).primaryColor)),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    child: Builder(builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.of(context).title_details),
                        content: Scrollbar(
                            child: SingleChildScrollView(
                          child: Text(element.text),
                        )),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(S.of(context).title_close))
                        ],
                      );
                    }));
              }),
        ));
      case "ol":
        List<Widget> list = [];
        int index = 1;
        element.children.forEach((c) {
          list.add(Text(
            "$index.${c.text}",
            style: TextStyle(fontSize: 18),
          ));
          index++;
        });
        return Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        );
        break;
      case "ul":
        List<Widget> list = [];
        element.children.forEach((c) {
          list.add(Text(
            "• ${c.text}",
            style: TextStyle(fontSize: 18),
          ));
        });
        return Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        );
      case "blockquote":
        Color background = HexColor.fromHex("#e7edf3");
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            color: background,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: contentPadding(Text(element.text)),
          ),
        );
      case "pre":
        Color backGroundColor = Colors.black87;
        return contentPadding(SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            color: backGroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                element.text,
                style: TextStyle(
                    color: ColorUtil.getTitleFormBackGround(backGroundColor)),
              ),
            ),
          ),
        ));
      default:
        return contentPadding(contentPadding(SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
              color: Colors.red,
              child: Text(
                "UnimplementedClass",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    child: Builder(builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Source"),
                        content: Text(element.toString()),
                      );
                    }));
              }),
        )));
    }
  }

  Widget contentPadding(Widget child) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: child,
    );
  }
}
