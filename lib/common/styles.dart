import 'package:flutter/material.dart';

const brightness = Brightness.light;
const primaryColor = Color(0xffe7a4a4);
const accentColor = Color(0xffd67b7b);
const red = Color(0xff996688);

const TST = TextStyle(
  fontFamily: "Montserrat",
  fontSize: 20,
  color: accentColor,
);

ThemeData androidTheme() {
  return ThemeData(
    buttonTheme: const ButtonThemeData(buttonColor: Color(0xffee9977)),
    useMaterial3: true,
    appBarTheme:
        const AppBarTheme(titleTextStyle: TST, color: Color(0xff996688)),
    brightness: brightness,
    textTheme: const TextTheme(
      titleSmall: TST, //subtitle2
      titleMedium: TST, //subtitle1
      titleLarge: TST, //headline6

      headlineSmall: TST, //headline5
      headlineLarge: TST,
      headlineMedium: TST, //headline4

      displaySmall: TST, //headline3
      displayMedium: TST, //headline2
      displayLarge: TST, //headline1

      bodySmall: TST, //caption
      bodyMedium: TST, //bodyText2
      bodyLarge: TST, //bodyText1

      labelSmall: TST, //Overline
      labelMedium: TST,
      labelLarge: TST, //button
    ),
  );
}
