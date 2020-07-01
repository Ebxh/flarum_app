import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/conf/app.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/Splash.dart';
import 'file:///C:/Users/me/AndroidStudioProjects/flarum_app/lib/ui/page/List.dart';
import 'package:core/ui/page/main/Tags.dart';
import 'package:core/ui/widgets.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  InitData initData;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool _isLoading = false;
  int pageIndex = 0;
  String discussionSort = "";
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor:
              initData != null && initData.forumInfo.themePrimaryColor != null
                  ? HexColor.fromHex(initData.forumInfo.themePrimaryColor)
                  : Colors.blue,
          brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh', 'CN'),
      ],
      home: Builder(builder: (BuildContext context) {
        textColor =
            TextColor.getTitleFormBackGround(Theme.of(context).primaryColor);

        if (initData == null && !_isLoading) {
          initApp(context).then((result) {
            setState(() {
              initData = result;
              _isLoading = false;
            });
          });
        }
        return _isLoading
            ? Scaffold(
                body: Center(
                child: CircularProgressIndicator(),
              ))
            : Scaffold(
                key: scaffold,
                appBar: AppBar(
                  title: ListTile(
                    title: Text(
                      initData.forumInfo.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(color: textColor, fontSize: 20),
                    ),
                    subtitle: pageIndex == 0
                        ? makeSortPopupMenu(
                            context,
                            discussionSort,
                            TextColor.getSubtitleFormBackGround(
                                Theme.of(context).primaryColor), (key) async {
                            setState(() {
                              discussionSort = key;
                              initData.discussions = null;
                            });
                            initData.discussions =
                                await Api.getDiscussions(key);
                            if (initData.discussions != null) {
                              setState(() {});
                            }
                          })
                        : null,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                      tooltip: S.of(context).title_switchSite,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: textColor,
                      ),
                      onPressed: () async {
                        var sites = await AppConfig.getSiteList();
                        showSites(context, sites);
                      }),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          color: textColor,
                        ),
                        onPressed: () {})
                  ],
                ),
                body: IndexedStack(
                  index: pageIndex,
                  children: <Widget>[
                    ListPage(initData, Theme.of(context).primaryColor),
                    TagsPage(initData)
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    tooltip: S.of(context).title_new_post,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.add,
                      color: textColor,
                    ),
                    onPressed: () {}),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IconButton(
                        tooltip: S.of(context).title_home,
                        icon: Icon(
                          Icons.home,
                          color: textColor,
                        ),
                        onPressed: () {
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                      ),
                      IconButton(
                          tooltip: S.of(context).title_tags,
                          icon: Icon(
                            Icons.apps,
                            color: textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              pageIndex = 1;
                            });
                          })
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Future<InitData> initApp(BuildContext context) async {
    _isLoading = true;
    await AppConfig.init();
    var sites = await AppConfig.getSiteList();
    ForumInfo info;
    if (sites == null || sites.length == 0) {
      info = await addSite(context, true);
    } else {
      if (sites.length < (await AppConfig.getSiteIndex())) {
        await AppConfig.setSiteIndex(0);
      }
      var site =
          (await AppConfig.getSiteList())[await AppConfig.getSiteIndex()];
      info = await Api.checkUrl(site.url);
    }
    if (info == null) {
      return null;
    }
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Splash(info);
    }));
    if (result != null || result is InitData) {
      return result;
    }
    return null;
  }

  void showSites(BuildContext ctx, List<SiteInfo> sites) async {
    showModalBottomSheet(
        context: ctx,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.1,
              title: Text(
                S.of(context).title_switchSite,
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    Navigator.pop(context);
                    var info = await addSite(context, false);
                    if (info != null) {
                      showSites(ctx, await AppConfig.getSiteList());
                    }
                  },
                  color: Colors.black,
                  tooltip: S.of(context).title_addSite,
                )
              ],
            ),
            body: ListView.builder(
                itemCount: sites.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(sites[index].url + "-$index"),
                    child: ListTile(
                      title: Text(sites[index].title),
                      subtitle: Text(sites[index].url.replaceAll("/api", "")),
                      leading: CachedNetworkImage(
                          height: 42, imageUrl: sites[index].faviconUrl),
                      onTap: () {
                        AppConfig.setSiteIndex(index);
                        refreshUI();
                        Navigator.pop(context);
                      },
                    ),
                    onDismissed: (DismissDirection direction) async {
                      sites.removeAt(index);
                      await AppConfig.removeSite(index);
                      if (index == await AppConfig.getSiteIndex()) {
                        Navigator.pop(context);
                        await AppConfig.setSiteIndex(0);
                        refreshUI();
                        return;
                      }
                      if ((await AppConfig.getSiteList()).length == 0) {
                        Navigator.pop(context);
                        refreshUI();
                      }
                    },
                  );
                }),
          );
        });
  }

  Future<ForumInfo> addSite(BuildContext context, bool firstAdd) async {
    TextEditingController urlInput = TextEditingController();
    String err;
    var isLoading = false;
    var canDismissible = true;
    if (firstAdd) {
      canDismissible = false;
    } else {
      canDismissible = !isLoading;
    }
    ForumInfo info = await showDialog(
        barrierDismissible: canDismissible,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            children: <Widget>[
              Text(
                firstAdd
                    ? S.of(context).title_welcome
                    : S.of(context).title_addSite,
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(S.of(context).content_add_flarum),
              ),
              TextField(
                controller: urlInput,
                decoration:
                    InputDecoration(hintText: "https://", errorText: err),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: RaisedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            isLoading = true;
                          });
                          var url = "${urlInput.text}/api";
                          var f = await Api.checkUrl(url);
                          if (f != null) {
                            AppConfig.addSite(
                                SiteInfo(f.apiUrl, f.title, f.faviconUrl));
                            var index = await AppConfig.getSiteIndex();
                            if (index == -1) {
                              index = 0;
                            }
                            await AppConfig.setSiteIndex(index);
                            Navigator.pop(context, f);
                          } else {
                            err = S.of(context).error_url;
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: Text(
                    isLoading ? "..." : S.of(context).button_done,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: isLoading
                      ? Colors.transparent
                      : Theme.of(context).primaryColor,
                ),
              )
            ],
          );
        });
    return info;
  }

  void refreshUI() {
    setState(() {
      discussionSort = "";
      initData = null;
    });
  }
}
