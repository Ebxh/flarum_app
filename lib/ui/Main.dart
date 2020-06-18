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
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
        return Scaffold(
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Text("hello"),
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
