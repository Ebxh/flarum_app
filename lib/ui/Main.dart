import 'package:core/api/Api.dart';
import 'package:core/api/data.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/conf/app.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/Setup.dart';
import 'package:core/ui/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  InitData initData;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
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
                  title: Text(initData.forumInfo.title),
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: () {
                        showModalBottomSheet(context: context, builder: (BuildContext context){
                          return Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.white,
                              title: Text(
                                "切换站点",
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
                            ),
                            body: ListView.builder(itemBuilder: (BuildContext context,int index){
                              return Text(index.toString());
                            }),
                          );
                        });
                      }),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.account_circle), onPressed: () {})
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add), onPressed: () {}),
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
                        icon: Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.apps,
                            color: Colors.white,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Future<InitData> initApp(BuildContext context) async {
    _isLoading = true;
    if (!await AppConfig.init()) {
      return null;
    }
    ForumInfo info;
    if (AppConfig.getUrlList() == null || AppConfig.getUrlList().length == 0) {
      info = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Setup();
      }));
    } else {
      var urlInfo = AppConfig.getIndexUrl();
      info = await Api.checkUrl(urlInfo.url);
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
}
