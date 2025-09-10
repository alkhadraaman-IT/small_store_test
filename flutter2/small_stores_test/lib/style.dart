import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// الألوان
//var color_main = Color(0xFFFFBC04);
//var color_Secondary = Colors.brown;
Color color_main = Color(0xFFFFBC04);
Color color_Secondary = Colors.brown; // خطأ أحمر
Color color_background = Colors.white; // خطأ أحمر

// دالة لحفظ اللون
Future<void> saveColor(Color c) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('color_main', c.value);
}

// دالة لتحميل اللون
Future<void> loadColor() async {
  final prefs = await SharedPreferences.getInstance();
  int? colorValue = prefs.getInt('color_main');

  if (colorValue != null) {
    color_main = Color(colorValue); // إذا موجود
  } else {
    color_main = Color(0xFFFFBC04); // إذا لا، رجع الافتراضي
  }
}

// أنماط النصوص
String font = 'Tajawal';
TextStyle  style_name_app_o(Color c) => TextStyle(color: c, fontSize: 28);// fontFamily: font);
var style_name_app_w = TextStyle(color: Colors.white, fontSize: 28,);//  fontFamily: font);
var style_text_normal = TextStyle(fontSize: 18, );// fontFamily: font);
var style_text_normal_w = TextStyle(color: Colors.white, fontSize: 18,);//  fontFamily: font);
TextStyle  style_text_button_normal (Color c) => TextStyle(color: c, fontSize: 18);//  fontFamily: font);
TextStyle  style_text_button_normal_2(Color c) => TextStyle(color: c, fontSize: 18);// fontFamily: font);
var style_text_button_normal_red = TextStyle(color: Colors.red, fontSize: 18, );// fontFamily: font);
TextStyle  style_text_big_2(Color c) => TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color_Secondary, height: 1.5);//Colors.grey[700], fontFamily: font
var style_text_titel = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);//, fontFamily: font );

// أنماط الأزرار (دالة)
ButtonStyle styleButton(Color c) => ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
  backgroundColor: MaterialStateProperty.all(c),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  shadowColor: MaterialStateProperty.all(Colors.black54),
  elevation: MaterialStateProperty.all(10.0),
  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);


// أنماط التبويبات (دالة)
TabBarTheme tabBarTheme(Color c) => TabBarTheme(
  indicator: UnderlineTabIndicator(
    borderSide: BorderSide(width: 3.0, color: c),
    insets: EdgeInsets.symmetric(horizontal: 16.0),
  ),
  labelColor: c,
  unselectedLabelColor: Colors.grey,
  labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  unselectedLabelStyle: TextStyle(fontSize: 14),
);

final tabBarDecoration = BoxDecoration(
  color: Colors.white,
  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
);

const drawerItemStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);