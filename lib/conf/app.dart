import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static SharedPreferences _prefs;

  static Future<bool> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      return true;
    }
    return false;
  }

  static Future<bool> addUrl(String title, String url) async {
    title = base64Encode(utf8.encode(title));
    url = base64Encode(utf8.encode(url));
    List<String> urlList = _prefs.getStringList("url_List");
    if (urlList == null) {
      urlList = [];
    }
    urlList.add("$title|$url");
    return await _prefs.setStringList("url_List", urlList);
  }

  static List<UrlInfo> getUrlList() {
    List<UrlInfo> list = [];
    var l = _prefs.getStringList("url_List");
    if (l == null) {
      return null;
    }
    l.forEach((String data) {
      var d = data.split("|");
      var title = d[0];
      var url = d[1];
      title = utf8.decode(base64Decode(title));
      url = utf8.decode(base64Decode(url));
      list.add(UrlInfo(title, url));
    });
    return list;
  }

  static UrlInfo getIndexUrl() {
    return getUrlList()[getUrlIndex()];
  }

  static Future<bool> setUrlIndex(int index) async {
    return await _prefs.setInt("url_index", index);
  }

  static int getUrlIndex() {
    return _prefs.getInt("url_index");
  }
}

class UrlInfo {
  String title;
  String url;

  UrlInfo(this.title, this.url);
}
