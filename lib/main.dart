import 'package:firstproj/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firstproj/login.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',  // This will set the 'login' route as the initial screen
      routes: {
        'login': (context) => MyLogin(),
        // 'login': (context) => HomePage(),
      },
    ),
  );
}
