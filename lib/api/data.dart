import 'package:core/api/decoder/discussions.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/api/decoder/tags.dart';

class InitData {
  ForumInfo forumInfo;
  Tags tags;
  Discussions discussions;

  InitData(this.forumInfo, this.tags, this.discussions);
}
