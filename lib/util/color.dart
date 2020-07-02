import 'package:flutter/material.dart';

extension HexColor on Color {
  /// https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  ///
  static Color fromHex(String hexString, {bool transparent}) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      var c = Color(int.parse(buffer.toString(), radix: 16));
      if ((transparent == null || !transparent) && c == Colors.transparent) {
        return Colors.black;
      }
      return c;
    } catch (_) {
      return Colors.white;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class ColorUtil {
  static Color getTitleFormBackGround(Color color) {
    return color.computeLuminance() < 0.5 ? Colors.white : Colors.black;
  }

  static Color getSubtitleFormBackGround(Color color) {
    return color.computeLuminance() < 0.5 ? Colors.white54 : Colors.black54;
  }

  static Brightness getBrightnessFromBackground(Color color) {
    return color.computeLuminance() < 0.5 ? Brightness.light : Brightness.dark;
  }
}
