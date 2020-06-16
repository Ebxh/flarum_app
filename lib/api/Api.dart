import 'dart:convert';

import 'package:core/api/decoder/forums.dart';
import 'package:core/util/String.dart';
import 'package:dio/dio.dart';

class Api {
  static Dio _dio = Dio();
  static Future<bool> checkUrl(String url) async {
    if (StringCheck(url).isUrl()) {
      print("Welcome ${ForumInfo.formJson((await _dio.get(url)).data).title}");
      return true;
    } else {
      return false;
    }
  }
}
