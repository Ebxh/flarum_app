import 'package:core/api/decoder/base.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

class GroupInfo {
  int id;
  String nameSingular;
  String namePlural;
  Color color;
  String icon;
  Map source;

  GroupInfo(this.id, this.nameSingular, this.namePlural, this.color, this.icon,this.source);

  factory GroupInfo.formMapAndId(Map m, int id) {
    return GroupInfo(
        id,
        m["nameSingular"],
        m["namePlural"],
        m["color"] == null ? Colors.white : HexColor.fromHex(m["color"]),
        m["icon"],m);
  }
}

class Groups {
  List<GroupInfo> list;

  Groups(this.list);

  factory Groups.formBase(BaseListBean base) {
    List<GroupInfo> list = [];
    base.data.list.forEach((m) {
      var g = GroupInfo.formMapAndId(m.attributes, m.id);
      list.add(g);
    });
    return Groups(list);
  }

  factory Groups.formJson(String data) {
    return Groups.formBase(BaseListBean.formJson(data));
  }
}
