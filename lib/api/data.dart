import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/api/decoder/tags.dart';
import 'package:core/api/decoder/users.dart';

class InitData {
  ForumInfo forumInfo;
  Tags tags;
  Discussions discussions;
  UserInfo loggedUser;

  InitData(this.forumInfo, this.tags, this.discussions, this.loggedUser);
}
