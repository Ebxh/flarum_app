import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/api/decoder/posts.dart';
import 'package:core/conf/app.dart';
import 'package:core/util/String.dart';
import 'package:dio/dio.dart';

import 'decoder/tags.dart';
import 'decoder/users.dart';

class Api {
  static Dio _dio;
  static String apiUrl = "";
  static Map<int, TagInfo> _tags;

  static Future<void> init(String url) async {
    apiUrl = url;
    _dio = Dio()..options.baseUrl = url;
  }

  static Future<ForumInfo> checkUrl(String url) async {
    if (StringCheck(url).isUrl()) {
      try {
        return ForumInfo.formJson((await Dio().get(url)).data);
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
      var t = TagInfo.getListFormJson((await _dio.get("/tags")).data);
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
    return DiscussionInfo.formJson((await _dio.get("/discussions/$id")).data);
  }

  static Future<Discussions> getDiscussionList(String sortKey,
      {String tagSlug}) async {
    String url;
    if (tagSlug == null) {
      url = "/discussions?include=user,tags"
          "&sort=$sortKey&";
    } else {
      url = "/discussions?include=user,tags"
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
    var url = "/posts?filter[id]=";
    l.forEach((id) {
      url += "$id,";
    });
    return Posts.formJson((await _dio.get(url)).data);
  }

  static Future<UserInfo> getLoggedInUserInfo() async {
    var t = await AppConfig.getLoggedInUser();
    if (t.uid == -1) {
      return null;
    }
    _dio
      ..options.baseUrl = apiUrl
      /// api is invalid?
      ..options.headers = {"Authentication": "Token ${t.token}"};
    return getUserInfoById(t.uid);
  }

  static Future<UserInfo> getUserInfoById(int id) async {
    try {
      return UserInfo.formJson((await _dio.get("users/$id")).data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> login(String username, String password) async {
    var result = (await _dio.post("/token", data: {
      "identification": username,
      "password": password,
    }));
    var userId = result.data["userId"];
    var token = result.data["token"];

    return AppConfig.setLoggedInUser(userId, token);
  }
}
