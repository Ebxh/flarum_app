import 'package:core/api/decoder/base.dart';
import 'package:core/api/decoder/groups.dart';

class UserInfo {
  int id;
  String username;
  String displayName;
  String avatarUrl;
  String joinTime;
  int discussionCount;
  int commentCount;
  bool canEdit;
  bool canDelete;
  String lastSeenAt;
  bool isEmailConfirmed;
  String email;
  bool canSuspend;
  Groups groups;
  Map source;

  UserInfo(
      this.id,
      this.username,
      this.displayName,
      this.avatarUrl,
      this.joinTime,
      this.discussionCount,
      this.commentCount,
      this.canEdit,
      this.canDelete,
      this.lastSeenAt,
      this.isEmailConfirmed,
      this.email,
      this.canSuspend,
      this.groups,
      this.source);

  factory UserInfo.formJson(String data) {
    return UserInfo.formBaseData(BaseBean.formJson(data).data);
  }

  factory UserInfo.formBaseData(BaseData data) {
    Map m = data.attributes;
    return UserInfo(
        data.id,
        m["username"],
        m["displayName"],
        m["avatarUrl"],
        m["joinTime"],
        m["discussionCount"],
        m["commentCount"],
        m["canEdit"],
        m["canDelete"],
        m["lastSeenAt"],
        m["isEmailConfirmed"],
        m["email"],
        m["canSuspend"],
        m["groups"],
        data.source);
  }

  static UserInfo deletedUser = UserInfo(-1, "[deleted]", "[deleted]", "", "",
      0, 0, false, false, "", false, "", false, null, null);
}
