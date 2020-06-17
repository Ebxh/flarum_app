import 'dart:collection';

import 'package:core/api/decoder/base.dart';

class TagInfo {
  String name;
  int id;
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
  LinkedHashMap<int, TagInfo> children;
  int parent;

  TagInfo(
      this.name,
      this.id,
      this.description,
      this.slug,
      this.color,
      this.backgroundUrl,
      this.backgroundMode,
      this.icon,
      this.discussionCount,
      this.position,
      this.defaultSort,
      this.isChild,
      this.isHidden,
      this.lastPostedAt,
      this.canStartDiscussion,
      this.canAddToDiscussion,
      this.children,
      this.parent);

  factory TagInfo.formMapAndId(Map m, int id) {
    return TagInfo(
        m["name"],
        id,
        m["description"],
        m["slug"],
        m["color"],
        m["backgroundUrl"],
        m["backgroundMode"],
        m["icon"],
        m["discussionCount"],
        m["position"],
        m["defaultSort"],
        m["isChild"],
        m["isHidden"],
        m["lastPostedAt"],
        m["canStartDiscussion"],
        m["canAddToDiscussion"],
        LinkedHashMap(),
        -1);
  }

  static Tags getListFormJson(String data) {
    return getListFormBase(BaseListBean.formJson(data));
  }

  static Tags getListFormBase(BaseListBean base) {
    Map<int, TagInfo> tags = {};
    List<TagInfo> children = [];
    List<TagInfo> miniTags = [];
    base.data.list.forEach((m) {
      var t = TagInfo.formMapAndId(m.attributes, int.parse(m.id));
      if (t.position == null) {
        miniTags.add(t);
      } else if (t.isChild) {
        int parentId = int.parse(m.relationships["parent"]["data"]["id"]);
        t.parent = parentId;
        children.add(t);
      } else {
        tags.addAll({t.id: t});
      }
      children.forEach((tag) {
        var parent = tags[tag.parent];
        parent.children.addAll({tag.position: tag});
      });
    });
    LinkedHashMap<int, TagInfo> linkedList = LinkedHashMap();
    tags.forEach((_, tag) {
      linkedList.addAll({tag.position: tag});
    });
    return Tags(linkedList, miniTags);
  }
}

class Tags {
  LinkedHashMap<int, TagInfo> tags;
  List<TagInfo> miniTags;

  Tags(this.tags, this.miniTags);
}