import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Colors.black,
      secondary: Color.fromRGBO(87, 96, 111,1.0),
      tertiary: Color.fromRGBO(241, 242, 246, 1.0),
      secondaryContainer: Color.fromRGBO(241, 196, 15,1.0),
      primaryContainer: Color.fromRGBO(215, 215, 215, 1.0),
    )
);