import 'package:cookie_jar/cookie_jar.dart';
import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/api/decoder/posts.dart';
import 'package:core/util/String.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'decoder/tags.dart';

class Api {
  static PersistCookieJar _cookieJar;
  static Dio _dio ;
  static String apiUrl = "";
  static Map<int, TagInfo> _tags;

  static init () async {
    _cookieJar = PersistCookieJar(
      dir: (await getApplicationDocumentsDirectory()).path +"/cookies"
    );
    _dio = Dio()..interceptors.add(CookieManager(_cookieJar));

  }

  static Future<ForumInfo> checkUrl(String url) async {
    if (StringCheck(url).isUrl()) {
      try {
        return ForumInfo.formJson((await _dio.get(url)).data);
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Tags> getTags() async {
    _tags = {};
    try {
      var t = TagInfo.getListFormJson((await _dio.get("$apiUrl/tags")).data);
      t.tags.forEach((_, tag) {
        if (tag.children != null) {
          tag.children.forEach((id, t) {
            _tags.addAll({t.id: t});
          });
        }
        _tags.addAll({tag.id: tag});
      });
      t.miniTags.forEach((id, tag) {
        _tags.addAll({tag.id: tag});
      });
      return t;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static TagInfo getTag(int id) {
    return _tags[id];
  }

  static Future<DiscussionInfo> getDiscussion(int id) async {
    return DiscussionInfo.formJson(
        (await _dio.get("$apiUrl/discussions/$id")).data);
  }

  static Future<Discussions> getDiscussionList(String sortKey,
      {String tagSlug}) async {
    String url;
    if (tagSlug == null) {
      url = "$apiUrl/discussions?include=user,tags"
          "&sort=$sortKey&";
    } else {
      url = "$apiUrl/discussions?include=user,tags"
          "&sort=$sortKey&filter[q]=tag:${Uri.encodeComponent(tagSlug)}&";
    }
    return getDiscussionListByUrl(url);
  }

  static Future<Discussions> getDiscussionListByUrl(String url) async {
    try {
      return Discussions.formJson((await _dio.get(url)).data);
    } catch (e) {
      print("Url:$url : $e");
      return null;
    }
  }

  static Future<Posts> getPostsById(List<int> l) async {
    var url = "$apiUrl/posts?filter[id]=";
    l.forEach((id) {
      url += "$id,";
    });
    return Posts.formJson((await _dio.get(url)).data);
  }
}
