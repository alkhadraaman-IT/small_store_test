import 'package:flutter/material.dart';
import 'package:small_stores_test/firstlaunch.dart';
import 'login.dart';
import 'style.dart';
import 'variables.dart';
import 'dart:async';

class Splashscreen extends StatefulWidget {
  @override
  _Splashscreen createState() => _Splashscreen();
}

class _Splashscreen extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstLaunch()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_main, // اللون البرتقالي
      body: Center(
        child: Text('app_name', style: style_name_app_w),
      ),
    );
  }
}