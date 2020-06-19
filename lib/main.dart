import 'package:core/ui/Main.dart';
import 'package:core/util/SystemUI.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
  SystemUI.setStatusBarColor(Colors.transparent, Brightness.light);
}
