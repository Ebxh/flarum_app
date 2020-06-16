import 'package:core/api/Api.dart';
import 'package:core/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  TextEditingController urlInput = TextEditingController();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool _isLoading = false;
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
        return Scaffold(
            key: scaffold,
            body: Center(
              child: Card(
                elevation: 0.5,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 10,
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        S.of(context).title_welcome,
                        style: TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(S.of(context).content_add_flarum),
                      ),
                      TextField(
                        controller: urlInput,
                        decoration: InputDecoration(
                            hintText: "https://discuss.flarum.org"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: RaisedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var f = await Api.checkUrl(
                                      urlInput.text + "/api/");
                                  if (f != null) {
                                    //do...
                                    
                                  } else {
                                    scaffold.currentState.showSnackBar(SnackBar(
                                        content:
                                            Text(S.of(context).error_url)));
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                          child: Text(
                            _isLoading ? "..." : S.of(context).button_done,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: _isLoading
                              ? Colors.transparent
                              : Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }
}
