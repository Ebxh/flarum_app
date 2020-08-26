import 'package:core/generated/l10n.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title_me,style: TextStyle(
          color: textColor
        ),),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left,color: textColor,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
