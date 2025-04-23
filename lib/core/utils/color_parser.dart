import 'package:flutter/material.dart';

class ColorParser {
  static Color fromARGBString(String strColor) {
    final channels = strColor.split('|');
    if (channels.length != 4) {
      return Colors.black;
    }
    final a = double.parse(channels[0]);
    final r = double.parse(channels[1]);
    final g = double.parse(channels[2]);
    final b = double.parse(channels[3]);
    return Color.from(alpha: a, red: r, green: g, blue: b);
  }

  static String toARGBString(Color color) {
    return '${color.a}|${color.r}|${color.g}|${color.b}';
  }
}
