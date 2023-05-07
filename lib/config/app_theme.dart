import 'package:flutter/material.dart';

class AppTheme {
  /////////////////////////////////////////
  ///////////// Dark Theme ///////////////
  /////////////////////////////////////////
  static final TextStyle darkDefaultTextStyle = TextStyle(
    fontFamily: 'Vazir',
    color: Colors.grey[200],
  );

  static ThemeData darkThemeData = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey.shade900,
    errorColor: Colors.redAccent,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.cyan,
      onPrimary: Colors.grey.shade900,
      secondary: Colors.deepOrange,
      onSecondary: Colors.white,
      background: Colors.grey.shade900,
      onBackground: Colors.white,
      shadow: Colors.cyan.withOpacity(0.4),
    ),
    textTheme: TextTheme(
      headline1: darkDefaultTextStyle.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
      headline2: darkDefaultTextStyle.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
      headline4: darkDefaultTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
      headline5: darkDefaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
      headline6: darkDefaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      bodyText1: darkDefaultTextStyle.copyWith(fontSize: 16),
      bodyText2: darkDefaultTextStyle.copyWith(fontSize: 14),
      button: darkDefaultTextStyle.copyWith(fontSize: 14),
      caption: darkDefaultTextStyle.copyWith(fontSize: 12, color: Colors.grey.shade500),
    ),
  );

  /////////////////////////////////////////
  ///////////// Light Theme ///////////////
  /////////////////////////////////////////

  static final TextStyle lightDefaultTextStyle = TextStyle(
    fontFamily: 'Vazir',
    color: Colors.grey[800],
  );

  static ThemeData lightThemeData = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.grey.shade200,
    errorColor: Colors.redAccent,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.cyan,
      onPrimary: Colors.grey.shade900,
      secondary: Colors.deepOrange,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.grey.shade900,
      shadow: Colors.black.withOpacity(0.1),
    ),
    textTheme: TextTheme(
      headline1: lightDefaultTextStyle.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
      headline2: lightDefaultTextStyle.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
      headline4: lightDefaultTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
      headline5: lightDefaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
      headline6: lightDefaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      bodyText1: lightDefaultTextStyle.copyWith(fontSize: 16),
      bodyText2: lightDefaultTextStyle.copyWith(fontSize: 14),
      button: lightDefaultTextStyle.copyWith(fontSize: 14),
      caption: lightDefaultTextStyle.copyWith(fontSize: 12, color: Colors.grey.shade500),
    ),
  );
}
