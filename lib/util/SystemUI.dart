import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUI {
  static void setStatusBarColor(Color color,Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness));
  }
}
