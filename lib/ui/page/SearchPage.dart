import 'package:core/api/data.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  final TagInfo tagInfo;
  final InitData initData;

  SearchPage(this.tagInfo, this.initData);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(primaryColor: Colors.white, brightness: Brightness.light);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear_all),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: () {
      Navigator.pop(context);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("result");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("sug");
  }
}
