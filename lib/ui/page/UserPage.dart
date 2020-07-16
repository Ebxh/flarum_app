import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api/decoder/users.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/widgets.dart';
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
    Color backgroundColor = Colors.black;
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title_user_info),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            index = index - 1;
            if (index == -1) {
              return Container(
                color: backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(
                      top: 10
                    ),child: Hero(
                        tag: widget.heroKey,
                        child: makeUserAvatarImage(
                            widget.userInfo, Theme.of(context).primaryColor, 128, 64)),),
                    Padding(
                      padding: EdgeInsets.only(top: 5,bottom: 20),
                      child: Text(
                        widget.userInfo.displayName,
                        style: TextStyle(color: textColor, fontSize: 22),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text("...");
            }
          }),
    );
  }
}
