import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/conf/app.dart';
import 'package:core/ui/widgets.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final ForumInfo info;

  Splash(this.info);

  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<Splash> {
  @override
  void initState() {
    Api.init(widget.info.apiUrl).then((_) async {
      var u = await Api.getLoggedInUserInfo();
      Future.wait([
        Api.getTags(),
        Api.getDiscussionList(AppConfig.SortLatest),
      ]).then((results) {
        Navigator.pop(
            context, InitData(widget.info, results[0], results[1], u));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SiteIcon(widget.info),
            ListTile(
              title: Text(
                widget.info.title,
                textAlign: TextAlign.center,
              ),
              subtitle: Text(widget.info.baseUrl, textAlign: TextAlign.center),
            )
          ],
        )),
        onWillPop: () {
          return Future.value(false);
        });
  }
}
