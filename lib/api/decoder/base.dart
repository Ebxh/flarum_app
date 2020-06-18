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

class BaseListBean {
  Links links;
  BaseDataList data;
  BaseIncluded included;

  BaseListBean(this.links, this.data, this.included);

  factory BaseListBean.formJson(String data) {
    _BaseBean _baseBean = _BaseBean.formJson(data);
    return BaseListBean(Links.formBase(_baseBean),
        BaseDataList.formBase(_baseBean), BaseIncluded.formBase(_baseBean));
  }
}

class _BaseBean {
  Map<String, dynamic> links;
  dynamic data;
  List included;

  _BaseBean(this.links, this.data, this.included);

  factory _BaseBean.formJson(String data) {
    Map j = json.decode(data);
    return _BaseBean(j["links"], j["data"], j["included"]);
  }
}

class BaseData {
  String type;
  int id;
  Map<String, dynamic> attributes;
  Map<String, dynamic> relationships;

  BaseData(this.type, this.id, this.attributes, this.relationships);

  factory BaseData.formBase(_BaseBean baseBean) {
    Map j = baseBean.data;
    return BaseData.formMap(j);
  }

  factory BaseData.formMap(Map j) {
    return BaseData(
        j["type"], int.parse(j["id"]), j["attributes"], j["relationships"]);
  }
}

class BaseDataList {
  List<BaseData> list;

  BaseDataList(this.list);

  factory BaseDataList.formBase(_BaseBean baseBean) {
    List l = baseBean.data;
    return BaseDataList.formList(l);
  }

  factory BaseDataList.formList(List l) {
    List<BaseData> li = [];
    l.forEach((map) {
      li.add(BaseData.formMap(map));
    });
    return BaseDataList(li);
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
    if (j == null) {
      return null;
    }
    return Links(j["first"], j["prev"], j["next"]);
  }
}
