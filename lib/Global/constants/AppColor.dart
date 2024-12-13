// App Colors

import 'package:flutter/material.dart';

class AppColor {
  static const transparent = Color(0x00FFFFFF);
  static const black = Color(0xff000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Colors.grey;
  static const yellow = Colors.yellow;
  static const teal = Colors.teal;
  static const green = Colors.green;
  static const amber = Colors.amber;
  static const red = Colors.red;
  static const orange = Colors.orange;
  static const orangeAccent = Colors.orangeAccent;
  static const blue = Colors.blue;
  static const blueGrey = Colors.blueGrey;
  static const pink = Colors.pink;
  static const deepPurple = Colors.deepPurple;
  static const hintTextColor = Color(0xff434A54);
  static const blueAccent = Colors.blueAccent;

  static const black87 = Colors.black87;
  static const black45 = Colors.black45;
  static const black54 = Colors.black54;

  // Hexadecimal Color
  static Color hexGrey = fromHex('#121212');

  static Color fromHex(
      String hexString,
      ) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write(
        'ff',
      );
    }
    buffer.write(
      hexString.replaceFirst(
        '#',
        '',
      ),
    );
    return Color(
      int.parse(
        buffer.toString(),
        radix: 16,
      ),
    );
  }
}
