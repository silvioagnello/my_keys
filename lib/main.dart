import 'package:flutter/material.dart';
import 'package:my_keys/models/user_model.dart';
import 'package:my_keys/pages/login_page2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'common/color_schemes.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
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

        home: LoginPage2(), //HomePage(), //
      ),
    ),
  );
}
