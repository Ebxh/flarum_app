import 'package:core/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
            body: Center(
          child: Card(
            elevation: 0.5,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    S.of(context).title_welcome,
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  Text(S.of(context).content_add_flarum),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "https://discuss.flarum.org/"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        S.of(context).button_done,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueAccent,
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
