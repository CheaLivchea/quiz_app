import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quiz_app/services/http_overrides.dart';
import 'package:quiz_app/views/pages/home.dart';
import 'package:quiz_app/views/pages/home_page.dart';
import 'package:quiz_app/views/pages/landing_page.dart';
import 'package:quiz_app/views/pages/leaderboard.dart';
import 'package:quiz_app/views/pages/loading_page.dart';
import 'package:quiz_app/views/pages/login.dart';
import 'package:quiz_app/views/pages/profile.dart';
import 'package:quiz_app/views/pages/quiz_screen.dart';
import 'package:quiz_app/views/pages/ranking.dart';
import 'package:quiz_app/views/pages/sign_in.dart';
import 'package:quiz_app/views/pages/welcome_page.dart';
import 'package:quiz_app/views/widgets/profile_grade.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF6A3FC6),
        brightness: Brightness.light,
      ),
      home: LandingPage(),
    );
  }
}
