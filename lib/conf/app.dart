import 'dart:convert';
import 'dart:io';

import 'package:core/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
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

  static Future<bool> setLoggedInUser(int userId, String token) async {
    int siteIndex = await getSiteIndex();
    var conf = await getConf();
    conf.sites[siteIndex].loggedInUserId = userId;
    conf.sites[siteIndex].userToken = token;
    return await saveConf(conf);
  }

  static Future<UserToken> getLoggedInUser() async {
    int siteIndex = await getSiteIndex();
    var conf = await getConf();
    return UserToken(
        conf.sites[siteIndex].loggedInUserId, conf.sites[siteIndex].userToken);
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

  /// launchURL with Chrome CustomTabs
  static void launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: CustomTabsOption(
          toolbarColor: Colors.white,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: const CustomTabsAnimation(
            startEnter: 'android:anim/slide_in_right',
            startExit: 'android:anim/slide_out_left',
            endEnter: 'android:anim/slide_in_left',
            endExit: 'android:anim/slide_out_right',
          ),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}

class UserToken {
  int uid;
  String token;

  UserToken(this.uid, this.token);
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
  int loggedInUserId;
  String userToken;
  Map source;

  SiteInfo(this.url, this.title, this.faviconUrl, this.loggedInUserId,
      this.userToken,
      {this.source});

  factory SiteInfo.formMap(Map m) {
    return SiteInfo(
        m["url"],
        m["title"],
        m["faviconUrl"] == null
            ? "https://discuss.flarum.org/assets/favicon-sltwadyk.png"
            : m["faviconUrl"],
        m["loggedInUserId"] == null ? -1 : int.parse(m["loggedInUserId"]),
        m["userToken"],
        source: m);
  }

  Map<String, String> toMap() {
    return {
      "url": url,
      "title": title,
      "faviconUrl": faviconUrl,
      "loggedInUserId": loggedInUserId.toString(),
      "userToken": userToken
    };
  }
}
