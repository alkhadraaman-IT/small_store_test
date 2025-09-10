import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'apiService/api.dart';
import 'firstlaunch.dart';
import 'login.dart';
import 'mainpageadmin.dart';
import 'mainpageuser.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';
import 'apiService/api_service.dart'; // مكان ملف ApiService

// ✅ أنشئ نسخة واحدة من ApiService (global)
final apiService = ApiService(client: http.Client());

class Splashscreen extends StatefulWidget {
  @override
  _Splashscreen createState() => _Splashscreen();
}

class _Splashscreen extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }


  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();

    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    String? access_token = prefs.getString('access_token');
    int? userType = prefs.getInt('userType');

    // ✅ حمّل التوكن بالـ ApiService (مرة وحدة بس)
    await apiService.loadTokenFromStorage();

    await Future.delayed(const Duration(seconds: 3)); // وقت السبلاتش

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstLaunch()),
      );
    } else if (access_token != null && userType != null) {
      // فيه مستخدم محفوظ
      User user = User(
        id: prefs.getInt('userId') ?? 0,
        name: prefs.getString('userName') ?? '',
        phone: prefs.getString('userPhone') ?? '',
        email: prefs.getString('userEmail') ?? '',
        password: prefs.getString('userPassword') ?? '',
        profile_photo: prefs.getString('userPhoto') ?? image_user_path,
        type: prefs.getInt('userType') ?? 1,
        status: prefs.getInt('userStatus') ?? 1,
      );
      await apiService.loadTokenFromStorage();

      if (user.type == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPageAdmin(user: user)),
        );
      } else if (user.type == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPageUser(user: user)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_main,
      body: Center(
        child: Text(app_name, style: style_name_app_w),
      ),
    );
  }
}
