import 'dart:collection';

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
}
