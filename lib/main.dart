import 'package:core/ui/Splash.dart';
import 'package:core/util/SystemUI.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Splash());
  SystemUI.setStatusBarColor(Colors.transparent, Brightness.dark);
}
