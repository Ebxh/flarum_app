import 'package:core/api/decoder/users.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final UserInfo userInfo;
  final Object heroKey;

  UserPage(this.userInfo, this.heroKey);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool s) {
            return [
              SliverAppBar(
                expandedHeight: 180,
                flexibleSpace: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(tag: widget.heroKey, child: Text("Avatar"))
                    ],
                  ),
                ),
              )
            ];
          },
          body: Text("123")),
    );
  }
}
