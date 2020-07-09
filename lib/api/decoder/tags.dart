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
  SplayTreeMap<int, TagInfo> children;
  int parent;
  Map source;

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
      this.parent,
      this.source);

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
        SplayTreeMap(),
        -1,
        m);
  }

  static Tags getListFormJson(String data) {
    return getListFormBase(BaseListBean.formJson(data));
  }

  static Tags getListFormBase(BaseListBean base) {
    Map<int, TagInfo> tags = {};
    List<TagInfo> children = [];
    Map<int, TagInfo> miniTags = {};
    base.data.list.forEach((m) {
      var t = TagInfo.formMapAndId(m.attributes, m.id);
      if (t.position == null) {
        t.children = null;
        miniTags.addAll({t.id: t});
      } else if (t.isChild) {
        int parentId = int.parse(m.relationships["parent"]["data"]["id"]);
        t.parent = parentId;
        children.add(t);
      } else {
        tags.addAll({t.id: t});
      }
    });
    children.forEach((tag) {
      var parent = tags[tag.parent];
      parent.children.addAll({tag.position: tag});
    });
    SplayTreeMap<int, TagInfo> splayTreeList = SplayTreeMap();
    tags.forEach((id, tag) {
      splayTreeList.addAll({tag.position: tag});
    });

    SplayTreeMap<int, TagInfo> positionFixedSplayTreeListList = SplayTreeMap();
    var i = 0;
    splayTreeList.forEach((position, t) {
      if (t.children.length == 0) {
        t.children = null;
      }
      positionFixedSplayTreeListList.addAll({i: t});
      i++;
    });

    return Tags(positionFixedSplayTreeListList, miniTags);
  }
}

class Tags {
  SplayTreeMap<int, TagInfo> tags;
  Map<int, TagInfo> miniTags;

  Tags(this.tags, this.miniTags);
}
