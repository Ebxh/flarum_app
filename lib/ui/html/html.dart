import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Widget getRichText(BuildContext context, dom.NodeList nodes,
      {List<InlineSpan> span}) {
    if (span == null) {
      span = <InlineSpan>[];
    }
    nodes.forEach((n) {
      if (n.hasChildNodes()) {
        getRichText(context, n.nodes, span: span);
      } else {
        switch (n.parent.localName) {
          case "p":
            if (n.toString() == "<html img>") {
              span.add(WidgetSpan(
                  child: contentPadding(Center(
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: n.attributes["src"],
                    placeholder: (BuildContext context, String url) {
                      return Icon(
                        Icons.image,
                        size: 64,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ))));
            } else {
              span.add(
                  TextSpan(text: "${n.text}", style: TextStyle(fontSize: 18)));
            }
            break;
          case "a":
            switch (n.parent.className) {
              case "UserMention":
                span.add(WidgetSpan(
                    child: InkWell(
                  child: Text("${n.text}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  onTap: () {},
                )));
                break;
              case "PostMention":
                span.add(WidgetSpan(
                    child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: FaIcon(
                          FontAwesomeIcons.reply,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      Text("${n.text}",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {},
                )));
                break;
              default:
                span.add(WidgetSpan(
                    child: InkWell(
                  child: Text("${n.text}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  onTap: () {},
                )));
                if (n.parent.className != "") {
                  print("UnimplementedUrlClass:${n.parent.className}");
                }
                break;
            }
            break;
          case "strong":
            span.add(TextSpan(
                text: "${n.text}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
            break;
            break;
          case "br":
            span.add(WidgetSpan(child: Text("\n")));
            break;
          case "em":
            span.add(TextSpan(
                text: n.text,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                )));
            break;
          case "code":
            span.add(TextSpan(
                text: n.text,
                style: TextStyle(
                    color: Colors.black54, backgroundColor: Colors.white)));
            break;
          default:
            print("UnimplementedNode:${n.parent.localName}");
            span.add(WidgetSpan(
                child: Text(
              "${n.text}",
              style: TextStyle(fontSize: 18),
            )));
            break;
        }
      }
    });
    return RichText(
        text: TextSpan(
            children: span,
            style: TextStyle(fontSize: 18, color: Colors.black)));
  }

  Widget getWidget(BuildContext context, dom.Element element) {
    switch (element.localName) {
      case "p":
        return contentPadding(getRichText(context, element.nodes));
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
                      var e = element.outerHtml.replaceAll("<details", "<p");
                      return AlertDialog(
                        title: Text(S.of(context).title_details),
                        content: Scrollbar(
                            child: SingleChildScrollView(
                          child: HtmlView(e),
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
            child: Padding(
              padding: EdgeInsets.all(15),
              child: getRichText(context, element.nodes),
            ),
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
                "UnimplementedNode",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    child: Builder(builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Source"),
                        content: Text(element.outerHtml),
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
