import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context){
        return Scaffold(
          body: Center(child: Text("Hello World"),),
        );
      }),
    );
  }
}
