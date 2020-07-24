import 'dart:convert';
import 'dart:io';

import 'package:core/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AppConfig {
  static File confFile;

  /// init confFile , first return true,else return false;

  static Future<void> init() async {
    if (confFile == null) {
      var appDocDir = await getApplicationDocumentsDirectory();
      confFile = File(appDocDir.path + "/flarum_conf.json");
      if (!await confFile.exists()) {
        confFile = await confFile.create();
      }
      return;
    }
    return;
  }

  static Future<bool> addSite(SiteInfo info) async {
    var conf = await getConf();
    conf.sites.add(info);
    return await saveConf(conf);
  }

  static Future<List<SiteInfo>> getSiteList() async {
    var conf = await getConf();
    return conf.sites;
  }

  static Future<bool> removeSite(int index) async {
    var conf = await getConf();
    conf.sites.removeAt(index);
    return await saveConf(conf);
  }

  static Future<bool> setSiteIndex(int index) async {
    var conf = await getConf();
    conf.siteIndex = index;
    return await saveConf(conf);
  }

  static Future<int> getSiteIndex() async {
    var conf = await getConf();
    return conf.siteIndex;
  }

  static Future<Conf> getConf() async {
    try {
      String j = await confFile.readAsString();
      if (j == null || j == "") {
        return Conf([], -1);
      }
      return Conf.formJson(j);
    } catch (e) {
      print("read Conf Error:$e");
      return null;
    }
  }

  static Future<bool> saveConf(Conf conf) async {
    var j = conf.toJson();
    try {
      confFile = await confFile.writeAsString(j);
      return true;
    } catch (e) {
      print("save Conf Error:$e");
      return false;
    }
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

class Conf {
  List<SiteInfo> sites;
  int siteIndex;

  Conf(this.sites, this.siteIndex);

  String toJson() {
    List<Map<String, String>> sites = [];
    this.sites.forEach((s) {
      sites.add(s.toMap());
    });
    Map<String, dynamic> map = {"sites": sites, "siteIndex": this.siteIndex};
    return json.encode(map);
  }

  factory Conf.formJson(String j) {
    Map m = json.decode(j);
    List<SiteInfo> sites = [];
    (m["sites"] as List).forEach((map) {
      sites.add(SiteInfo.formMap(map));
    });
    return Conf(sites, m["siteIndex"]);
  }
}

class SiteInfo {
  String url;
  String title;
  String faviconUrl;
  Map source;

  SiteInfo(this.url, this.title, this.faviconUrl, {this.source});

  factory SiteInfo.formMap(Map m) {
    return SiteInfo(
        m["url"],
        m["title"],
        m["faviconUrl"] == null
            ? "https://discuss.flarum.org/assets/favicon-sltwadyk.png"
            : m["faviconUrl"],
        source: m);
  }

  Map<String, String> toMap() {
    return {
      "url": url,
      "title": title,
      "faviconUrl": faviconUrl,
    };
  }
}
