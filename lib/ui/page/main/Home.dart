import 'package:core/api/data.dart';
import 'package:flutter/material.dart';

import '../../widgets.dart';

class HomePage extends StatefulWidget {
  final InitData initData;

  HomePage(this.initData);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return widget.initData.discussions == null ?
        Center(
          child: CircularProgressIndicator(),
        )
        : ListView.builder(
        itemCount: widget.initData.discussions.list.length,
        itemBuilder: (BuildContext context, int index) {
          var d = widget.initData.discussions.list[index];
          return ListTile(title: Text(d.title), leading: Avatar(d.user));
        });
  }
}
