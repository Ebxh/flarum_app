import 'package:core/api/decoder/discussions.dart';
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
  UserInfo user;
  UserInfo editedUser;
  DiscussionInfo discussion;
  List<UserInfo> likes;
  List<PostInfo> mentionedBy;

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
      this.mentionedBy);

  factory PostInfo.formMapAndId(Map m, int id) {
    return PostInfo(
        id,
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
        null);
  }
}
