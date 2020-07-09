import 'package:core/api/decoder/base.dart';
import 'package:core/api/decoder/posts.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/api/decoder/users.dart';

class DiscussionInfo {
  int id;
  String title;
  String slug;
  int commentCount;
  int participantCount;
  String createdAt;
  String lastPostedAt;
  int lastPostNumber;
  bool canReply;
  bool canRename;
  bool canDelete;
  bool canHide;
  bool isApproved;
  bool isSticky;
  bool canSticky;
  bool isLocked;
  bool canLock;
  bool canTag;
  UserInfo user;
  UserInfo lastPostedUser;
  PostInfo firstPost;
  List<int> postsIdList;
  Map<int, PostInfo> posts;
  Map<int, UserInfo> users;
  List<TagInfo> tags;
  Map source;

  DiscussionInfo(
      this.id,
      this.title,
      this.slug,
      this.commentCount,
      this.participantCount,
      this.createdAt,
      this.lastPostedAt,
      this.lastPostNumber,
      this.canReply,
      this.canRename,
      this.canDelete,
      this.canHide,
      this.isApproved,
      this.isSticky,
      this.canSticky,
      this.isLocked,
      this.canLock,
      this.canTag,
      this.user,
      this.lastPostedUser,
      this.firstPost,
      this.postsIdList,
      this.posts,
      this.users,
      this.tags,
      this.source);

  factory DiscussionInfo.formMaoAndId(Map m, int id) {
    return DiscussionInfo(
        id,
        m["title"],
        m["slug"],
        m["commentCount"],
        m["participantCount"],
        m["createdAt"],
        m["lastPostedAt"],
        m["lastPostNumber"],
        m["canReply"],
        m["canRename"],
        m["canDelete"],
        m["canHide"],
        m["isApproved"],
        m["isSticky"],
        m["canSticky"],
        m["isLocked"],
        m["canLock"],
        m["canTag"],
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        m);
  }

  static bool isInitDiscussion(DiscussionInfo discussionInfo) {
    return discussionInfo.firstPost != null ||
        discussionInfo.posts == null ||
        discussionInfo.postsIdList == null;
  }

  factory DiscussionInfo.formJson(String j) {
    return DiscussionInfo.formBase(BaseBean.formJson(j));
  }

  factory DiscussionInfo.formBase(BaseBean base) {
    Map<int, PostInfo> allPosts = {};
    Map<int, PostInfo> posts = {};
    List<int> postsId = [];
    List<TagInfo> tags = [];
    Map<int, UserInfo> users = {};
    var d = DiscussionInfo.formMaoAndId(base.data.attributes, base.data.id);

    base.included.data.forEach((data) {
      switch (data.type) {
        case "posts":
          var p = PostInfo.formBaseData(data);
          allPosts.addAll({p.id: p});
          break;
        case "tags":
          var t = TagInfo.formMapAndId(data.attributes, data.id);
          tags.add(t);
          break;
        case "users":
          var u = UserInfo.formMapAndId(data.attributes, data.id);
          users.addAll({u.id: u});
          break;
      }
    });
    (base.data.relationships["posts"]["data"] as List).forEach((data) {
      postsId.add(int.parse(data["id"]));
    });

    postsId.forEach((id) {
      var p = allPosts[id];
      if (p != null) {
        posts.addAll({id: p});
      }
    });

    d.posts = posts;
    d.postsIdList = postsId;
    d.users = users;
    return d;
  }
}

class Discussions {
  List<DiscussionInfo> list;
  Links links;

  Discussions(this.list, this.links);

  factory Discussions.formJson(String data) {
    return Discussions.formBase(BaseListBean.formJson(data));
  }

  factory Discussions.formBase(BaseListBean base) {
    List<DiscussionInfo> list = [];
    Map<int, UserInfo> users = {};
    Map<int, PostInfo> posts = {};
    Map<int, TagInfo> tags = {};
    base.included.data.forEach((data) {
      switch (data.type) {
        case "users":
          var u = UserInfo.formMapAndId(data.attributes, data.id);
          users.addAll({u.id: u});
          break;
        case "posts":
          var p = PostInfo.formMapAndId(data.attributes, data.id);
          posts.addAll({p.id: p});
          break;
        case "tags":
          var t = TagInfo.formMapAndId(data.attributes, data.id);
          tags.addAll({t.id: t});
          break;
      }
    });
    base.data.list.forEach((data) {
      var d = DiscussionInfo.formMaoAndId(data.attributes, data.id);
      if (data.relationships["user"] == null) {
        d.user = UserInfo.deletedUser;
      } else {
        d.user = users[int.parse(data.relationships["user"]["data"]["id"])];
      }
      if (data.relationships["lastPostedUser"] == null) {
        d.lastPostedUser = UserInfo.deletedUser;
      } else {
        d.lastPostedUser = users[
            int.parse(data.relationships["lastPostedUser"]["data"]["id"])];
      }

      /// in https://discuss.flarum.org/?sort=oldest , some old discussions not have firstPost .
      if (data.relationships["firstPost"] != null) {
        d.firstPost =
            posts[int.parse(data.relationships["firstPost"]["data"]["id"])];
      } else {
        d.firstPost = null;
      }

      List<TagInfo> t = [];
      (data.relationships["tags"]["data"] as List).forEach((m) {
        Map map = m;
        t.add(tags[int.parse(map["id"])]);
      });
      d.tags = t;
      list.add(d);
    });
    return Discussions(list, base.links);
  }
}
