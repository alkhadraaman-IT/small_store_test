import 'package:flutter/material.dart';

// الألوان
var color_main = Color(0xFFFFBC04);
var color_Secondary = Colors.brown;

// أنماط النصوص
String font = 'Tajawal';
var style_name_app_o = TextStyle(color: color_main, fontSize: 32, fontFamily: font);
var style_name_app_w = TextStyle(color: Colors.white, fontSize: 32, fontFamily: font);
var style_text_normal = TextStyle(fontSize: 18, fontFamily: font);
var style_text_normal_w = TextStyle(color: Colors.white, fontSize: 18, fontFamily: font);
var style_text_button_normal = TextStyle(color: color_main, fontSize: 18, fontFamily: font);
var style_text_button_normal_2 = TextStyle(color: color_Secondary, fontSize: 18, fontFamily: font);
var style_text_button_normal_red = TextStyle(color: Colors.red, fontSize: 18, fontFamily: font);
var style_text_big_2= TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: color_Secondary, height: 1.5,);//Colors.grey[700]
var style_text_titel = TextStyle(fontSize: 24, fontFamily: font, fontWeight: FontWeight.bold);

// أنماط الأزرار
var style_button = ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
  backgroundColor: MaterialStateProperty.all(color_main),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  shadowColor: MaterialStateProperty.all(Colors.black54),
  elevation: MaterialStateProperty.all(10.0),
  textStyle: MaterialStateProperty.all(
    TextStyle(fontSize: 24, fontFamily: font),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

// أنماط التبويبات
final tabBarTheme = TabBarTheme(
  indicator: UnderlineTabIndicator(
    borderSide: BorderSide(width: 3.0, color: color_main),
    insets: EdgeInsets.symmetric(horizontal: 16.0),
  ),
  labelColor: color_main,
  unselectedLabelColor: Colors.grey,
  labelStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: font,
  ),
  unselectedLabelStyle: TextStyle(
    fontSize: 14,
    fontFamily: font,
  ),
);

final tabBarDecoration = BoxDecoration(
  color: Colors.white,
  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
);

const drawerItemStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);