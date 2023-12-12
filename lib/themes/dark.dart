import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      background: Color.fromRGBO(32, 32, 37, 1),
      primary: Colors.white,
      secondary: Colors.white54,
      tertiary: Color.fromRGBO(82, 82, 84, 1.0),
      secondaryContainer: Color.fromRGBO(255, 165, 2, 1.0),
    )
);