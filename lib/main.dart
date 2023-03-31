import 'package:flutter/material.dart';
import 'package:flutter_voice_assistant/home_page.dart';
import 'package:flutter_voice_assistant/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: Pallete.whiteColor,
            appBarTheme: AppBarTheme(backgroundColor: Pallete.whiteColor)),
        home: HomePage());
  }
}
