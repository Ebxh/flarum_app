import 'package:core/api/decoder/forums.dart';
import 'package:core/util/String.dart';
import 'package:dio/dio.dart';

class Api {
  static Dio _dio = Dio();
  static Future<ForumInfo> checkUrl(String url) async {
    if (StringCheck(url).isUrl()) {
      try {
        return ForumInfo.formJson((await _dio.get(url)).data);
      } catch (_){
        return null;
      }
    } else {
      return null;
    }
  }
}
