import 'package:flutter/material.dart';
import 'package:my_keys/pages/home_page.dart';
import 'common/color_schemes.g.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My_Keys',
      themeMode: ThemeMode.light, //dark, //
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ), //androidTheme(),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ), //,

      home: const HomePage(),
    ),
  );
}
