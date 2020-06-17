import 'package:core/api/decoder/base.dart';

class TagInfo {
  String name;
  String description;
  String slug;
  String color;
  String backgroundUrl;
  String backgroundMode;
  String icon;
  int discussionCount;
  int position;
  String defaultSort;
  bool isChild;
  bool isHidden;
  String lastPostedAt;
  bool canStartDiscussion;
  bool canAddToDiscussion;
  List<TagInfo> children;

  static getListFormBase(BaseListBean base) {
    List<TagInfo> tags = [];
    List<TagInfo> children = [];
    // TODO
  }
}