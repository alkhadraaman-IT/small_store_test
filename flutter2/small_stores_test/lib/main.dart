import 'package:flutter/material.dart';
import 'package:small_stores_test/addannouncement.dart';
import 'package:small_stores_test/addproduct.dart';
import 'package:small_stores_test/addstore.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:small_stores_test/editproduct.dart';
import 'package:small_stores_test/login.dart';
import 'package:small_stores_test/product.dart';
import 'about.dart';
import 'editprofile.dart';
import 'home.dart';
import 'mainpageuser.dart';
import 'showproduct.dart';
import 'showstore.dart';
import 'showstoredata.dart';
import 'splashscreen.dart';
import 'store.dart';
import 'style.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('ar'),
      title: 'Flutter ٍStore',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color_Secondary), //  لون الخط السفلي عند التحديد
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), //  لون الخط في الحالة العادية
          ),
          labelStyle: TextStyle(color: color_Secondary), //  لون النص عند التحديد
        ),
      ),

      //  هذا السطر بيضمن إنو كل الشاشات تتبع RTL
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      home: MainPageUser(),

    );
  }
}

