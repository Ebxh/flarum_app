import 'package:core/api/Api.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/ui/widgets.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  final ForumInfo info;

  Splash(this.info);

  @override
  Widget build(BuildContext context) {
    loadData(context);
    return Scaffold(
        bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SiteIcon(info),
        ListTile(
          title: Text(
            info.title,
            textAlign: TextAlign.center,
          ),
          subtitle: Text(info.baseUrl, textAlign: TextAlign.center),
        )
      ],
    ));
  }

  void loadData(BuildContext context) async {
    Api.apiUrl = info.apiUrl;
    var tags = await Api.getTags();
  }
}
