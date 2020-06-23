import 'package:core/api/data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final InitData initData;

  HomePage(this.initData);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.initData.discussions.list.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.initData.discussions.list[index].title),
          );
        });
  }
}
