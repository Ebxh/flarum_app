import 'package:core/api/Api.dart';
import 'package:core/conf/app.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/util/color.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = ColorUtil.getTitleFormBackGround(backgroundColor);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        brightness: ColorUtil.getBrightnessFromBackground(backgroundColor),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  S.of(context).title_login,
                  style: TextStyle(color: textColor, fontSize: 24),
                ),
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                      labelText: S.of(context).title_email_or_username),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: S.of(context).title_password),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        color: Colors.blue,
                        child: Text(S.of(context).title_login),
                        onPressed: isLoading
                            ? null
                            : () async {
                                /*
                                if (userNameController.text == "" ||
                                    passwordController.text == "") {
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                bool ok = await Api.login(
                                    userNameController.text,
                                    passwordController.text);
                                if (ok) {
                                  Navigator.pop(context, ok);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                        */
                              }),
                    RaisedButton(
                        child: Text(S.of(context).title_singUp),
                        onPressed: () {
                          AppConfig.launchURL(
                              context, Api.apiUrl.replaceAll("api", ""));
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
