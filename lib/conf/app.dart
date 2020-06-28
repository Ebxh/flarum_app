import 'dart:convert';

import 'package:core/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
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

  static Future<bool> addSite(
      String title, String url, String faviconUrl) async {
    title = base64Encode(utf8.encode(title));
    url = base64Encode(utf8.encode(url));
    if (faviconUrl == null) {
      faviconUrl = "https://discuss.flarum.org/assets/favicon-sltwadyk.png";
    }
    faviconUrl = base64Encode(utf8.encode(faviconUrl));
    List<String> urlList = _prefs.getStringList("url_List");
    if (urlList == null) {
      urlList = [];
    }
    urlList.add("$title|$url|$faviconUrl");
    return await _prefs.setStringList("url_List", urlList);
  }

  static List<UrlInfo> getSiteList() {
    List<UrlInfo> list = [];
    var l = _prefs.getStringList("url_List");
    if (l == null) {
      return null;
    }
    l.forEach((String data) {
      var d = data.split("|");
      var title = d[0];
      var url = d[1];
      var logoUrl = d[2];
      title = utf8.decode(base64Decode(title));
      url = utf8.decode(base64Decode(url));
      logoUrl = utf8.decode(base64Decode(logoUrl));
      list.add(UrlInfo(title, url, logoUrl));
    });
    return list;
  }

  static Future<bool> removeSite(int index) async {
    var l = getSiteList();
    l.removeAt(index);
    List<String> _list = [];
    l.forEach((site) {
      _list.add(site.toString());
    });
    return await _prefs.setStringList("url_List", _list);
  }

  static Future<bool> setUrlIndex(int index) async {
    return await _prefs.setInt("url_index", index);
  }

  static int getUrlIndex() {
    return _prefs.getInt("url_index");
  }


  /// Discussion Sort keys
  static const String SortLatest = "";
  static const String SortTop = "-commentCount";
  static const String SortNewest = "-createdAt";
  static const String SortOldest = "createdAt";

  /// return <id,i10n_name>
  static Map<String, String> getDiscussionSortInfo(BuildContext context) {
    return {
      SortLatest: S.of(context).subtitle_latest,
      SortTop: S.of(context).subtitle_top,
      SortNewest: S.of(context).subtitle_newest,
      SortOldest: S.of(context).subtitle_oldest,
    };
  }


}

class UrlInfo {
  String title;
  String url;
  String faviconUrl;

  UrlInfo(this.title, this.url, this.faviconUrl);

  @override
  String toString() {
    var t = base64Encode(utf8.encode(title));
    var u = base64Encode(utf8.encode(url));
    var f = base64Encode(utf8.encode(faviconUrl));

    return "$t|$u|$f";
  }
}
