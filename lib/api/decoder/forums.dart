import 'package:core/api/decoder/base.dart';

class ForumInfo {
  String title;
  String description;
  bool showLanguageSelector;
  String baseUrl;
  String basePath;
  bool debug;
  String apiUrl;
  String welcomeTitle;
  String welcomeMessage;
  String themePrimaryColor;
  String themeSecondaryColor;
  String logoUrl;
  String faviconUrl;
  String headerHtml;
  String footerHtml;
  bool allowSignUp;
  String defaultRoute;
  bool canViewDiscussions;
  bool canStartDiscussion;
  bool canViewUserList;
  bool canViewFlags;
  String guidelinesUrl;
  String minPrimaryTags;
  String maxPrimaryTags;
  String minSecondaryTags;
  String maxSecondaryTags;

  ForumInfo(
      this.title,
      this.description,
      this.showLanguageSelector,
      this.baseUrl,
      this.basePath,
      this.debug,
      this.apiUrl,
      this.welcomeTitle,
      this.welcomeMessage,
      this.themePrimaryColor,
      this.themeSecondaryColor,
      this.logoUrl,
      this.faviconUrl,
      this.headerHtml,
      this.footerHtml,
      this.allowSignUp,
      this.defaultRoute,
      this.canViewDiscussions,
      this.canStartDiscussion,
      this.canViewUserList,
      this.canViewFlags,
      this.guidelinesUrl,
      this.minPrimaryTags,
      this.maxPrimaryTags,
      this.minSecondaryTags,
      this.maxSecondaryTags);

  factory ForumInfo.formJson(String data) {
    var base = BaseBean.formJson(data);
    return ForumInfo.formBase(base);
  }

  factory ForumInfo.formBase(BaseBean base) {
    if (base.data.type == "forums") {
      Map info = base.data.attributes;
      return ForumInfo(
          info["title"],
          info["description"],
          info["showLanguageSelector"],
          info["baseUrl"],
          info["basePath"],
          info["debug"],
          info["apiUrl"],
          info["welcomeTitle"],
          info["welcomeMessage"],
          info["themePrimaryColor"],
          info["themeSecondaryColor"],
          info["logoUrl"],
          info["faviconUrl"],
          info["headerHtml"],
          info["footerHtml"],
          info["allowSignUp"],
          info["defaultRoute"],
          info["canViewDiscussions"],
          info["canStartDiscussion"],
          info["canViewUserList"],
          info["canViewFlags"],
          info["guidelinesUrl"],
          info["minPrimaryTags"],
          info["maxPrimaryTags"],
          info["minSecondaryTags"],
          info["maxSecondaryTags"]);
    }
    return null;
  }
}
