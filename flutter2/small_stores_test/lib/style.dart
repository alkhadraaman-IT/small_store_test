import 'package:flutter/material.dart';

//الوان

var color_main=Color(0xFFFFBC04);
Color color_Secondary = Colors.brown;

//styie text
String font='Tajawal';
var style_name_app_o=TextStyle(color: color_main,fontSize: 32,fontFamily: font);
var style_name_app_w=TextStyle(color: Colors.white,fontSize: 32,fontFamily: font);
var style_text_normal=TextStyle(fontSize: 18,fontFamily: font);
var style_text_normal_w=TextStyle(color: Colors.white,fontSize: 18,fontFamily: font);
var style_text_button_normal=TextStyle(color: color_main,fontSize: 18,fontFamily: font);
var style_text_titel=TextStyle(fontSize: 24,fontFamily: font,fontWeight: FontWeight.bold, );
//var style_text_titel=TextStyle(color: color_main,fontSize: 24,fontFamily: font);
var style_button = ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
  backgroundColor: MaterialStateProperty.all(color_main),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  shadowColor: MaterialStateProperty.all(Colors.black54), // لون الظل هنا
  elevation: MaterialStateProperty.all(10.0), // ارتفاع الظل
  textStyle: MaterialStateProperty.all(
    TextStyle(
      fontSize: 24,
      fontFamily: font,
    ),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);


const drawerItemStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);
