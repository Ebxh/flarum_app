import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/util/String.dart';
import 'package:dio/dio.dart';

import 'decoder/tags.dart';

class Api {
  static Dio _dio = Dio();
  static String apiUrl = "";
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
    try {
      return TagInfo.getListFormJson((await _dio.get("$apiUrl/tags")).data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Discussions> getDiscussions(String sortKey,
      {String tagSlug}) async {
    String url;
    if (tagSlug == null) {
      url = "$apiUrl//discussions?include=user,lastPostedUser,firstPost,tags"
          "&sort=$sortKey&";
    } else {
      url = "$apiUrl//discussions?include=user,lastPostedUser,firstPost,tags"
          "&sort=$sortKey&filter[q]= tag:$tagSlug&";
    }
    return getDiscussionsByUrl(url);
  }

  static Future<Discussions> getDiscussionsByUrl(String url) async {
    try {
      return Discussions.formJson((await _dio.get(url)).data);
    } catch (e) {
      print("Url:$url : $e");
      return null;
    }
  }
}
