import 'dart:convert';

class BaseBean {
  Links links;
  BaseData data;
  BaseIncluded included;

  BaseBean(this.links, this.data, this.included);

  factory BaseBean.formJson(String data) {
    _BaseBean _baseBean = _BaseBean.formJson(data);
    return BaseBean(Links.formBase(_baseBean), BaseData.formBase(_baseBean),
        BaseIncluded.formBase(_baseBean));
  }
}

class _BaseBean {
  Map<String, String> links;
  Map<String, dynamic> data;
  List included;

  _BaseBean(this.links, this.data, this.included);

  factory _BaseBean.formJson(String data) {
    Map j = json.decode(data);
    return _BaseBean(j["links"], j["data"], j["included"]);
  }
}

class BaseData {
  String type;
  String id;
  Map<String,dynamic> attributes;
  Map<String,dynamic> relationships;

  BaseData(this.type, this.id, this.attributes, this.relationships);

  factory BaseData.formBase(_BaseBean baseBean) {
    Map j = baseBean.data;
    return BaseData(j["type"], j["id"], j["attributes"], j["relationships"]);
  }

  factory BaseData.formMap(Map map) {
    Map j = map;
    return BaseData(j["type"], j["id"], j["attributes"], j["relationships"]);
  }
}

class BaseIncluded {
  List<BaseData> data;

  BaseIncluded(this.data);

  factory BaseIncluded.formBase(_BaseBean baseBean) {
    List l = baseBean.included;
    List<BaseData> data = [];
    if (l != null) {
      l.forEach((map) {
        data.add(BaseData.formMap(map));
      });
      return BaseIncluded(data);
    }
    return BaseIncluded(null);
  }
}

class Links {
  String first;
  String prev;
  String next;

  Links(this.first, this.prev, this.next);

  factory Links.formBase(_BaseBean baseBean) {
    Map j = baseBean.links;
    if (j == null){
      return null;
    }
    return Links(j["first"], j["prev"], j["next"]);
  }
}
