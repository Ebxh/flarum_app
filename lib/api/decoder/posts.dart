import 'package:core/api/decoder/base.dart';
import 'package:core/api/decoder/users.dart';

class PostInfo {
  int id;
  int number;
  String createdAt;
  String contentType;
  String contentHtml;
  String editedAt;
  bool canEdit;
  bool canDelete;
  bool canHide;
  bool isApproved;
  bool canApprove;
  bool canFlag;
  bool canLike;
  int user;
  int editedUser;
  int discussion;
  List<int> likes;
  List<int> mentionedBy;
  Map source;

  PostInfo(
      this.id,
      this.number,
      this.createdAt,
      this.contentType,
      this.contentHtml,
      this.editedAt,
      this.canEdit,
      this.canDelete,
      this.canHide,
      this.isApproved,
      this.canApprove,
      this.canFlag,
      this.canLike,
      this.user,
      this.editedUser,
      this.discussion,
      this.likes,
      this.mentionedBy,
      this.source);

  factory PostInfo.formBaseData(BaseData data) {
    var m = data.attributes;
    var p = PostInfo(
        data.id,
        m["number"],
        m["createdAt"],
        m["contentType"],
        m["contentHtml"],
        m["editedAt"],
        m["canEdit"],
        m["canDelete"],
        m["canHide"],
        m["isApproved"],
        m["canApprove"],
        m["canFlag"],
        m["canLike"],
        null,
        null,
        null,
        null,
        null,
        data.source);
    List<int> likes = [];
    List<int> mentionedBy = [];
    var discussion = int.parse(data.relationships["discussion"]["data"]["id"]);
    var user;

    /// https://discuss.flarum.org/api/discussions/18316
    if (data.relationships["user"] != null) {
      user = int.parse(data.relationships["user"]["data"]["id"]);
    }
    var editedUser;
    if (data.relationships["editedUser"] != null) {
      editedUser = int.parse(data.relationships["editedUser"]["data"]["id"]);
    }
    if (data.relationships["likes"] != null) {
      (data.relationships["likes"]["data"] as List).forEach((m) {
        m = m as Map;
        likes.add(int.parse(m["id"]));
      });
    }
    if (data.relationships["mentionedBy"] != null) {
      (data.relationships["mentionedBy"]["data"] as List).forEach((m) {
        m = m as Map;
        mentionedBy.add(int.parse(m["id"]));
      });
    }

    p.likes = likes;
    p.discussion = discussion;
    p.editedUser = editedUser;
    p.user = user;
    p.mentionedBy = mentionedBy;
    return p;
  }
}

class Posts {
  Map<int, PostInfo> posts;
  Map<int, UserInfo> users;
  Posts(this.posts, this.users);

  factory Posts.formJson(String data) {
    return Posts.formBaseList(BaseListBean.formJson(data));
  }

  factory Posts.formBaseList(BaseListBean baseBean) {
    Map<int, PostInfo> posts = {};
    Map<int, UserInfo> users = {};
    baseBean.data.list.forEach((e) {
      if (e.type == "posts") {
        var p = PostInfo.formBaseData(e);
        posts.addAll({p.id: p});
      }
    });
    baseBean.included.data.forEach((e) {
      switch (e.type) {
        case "users":
          var u = UserInfo.formBaseData(e);
          users.addAll({u.id: u});
          break;
        case "posts":
          var p = PostInfo.formBaseData(e);
          posts.addAll({p.id: p});
          break;
      }
    });
    return Posts(posts, users);
  }
}
