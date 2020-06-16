import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static SharedPreferences _prefs;

  static Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return;
  }

  static Future<bool> addUrl(String url) async {
    List<String> urlList = _prefs.getStringList("url_List");
    urlList.add(url);
    return await _prefs.setStringList("url_List", urlList);
  }

  static List<String> getUrlList() {
    return _prefs.getStringList("url_List");
  }

  static Future<bool> setUrlIndex(int index) async {
    return await _prefs.setInt("url_index", index);
  }

  static int getUrlIndex() {
    return _prefs.getInt("url_index");
  }
}
