import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:small_stores_test/about.dart';
import 'package:small_stores_test/advice.dart';
import 'package:small_stores_test/favorite.dart';
import 'package:small_stores_test/login.dart';
import 'package:small_stores_test/mainpageadmin.dart';
import 'package:small_stores_test/profile.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

import 'announcement.dart';
import 'mainpageuser.dart';
import 'models/usermodel.dart';

class CustomDrawer extends StatelessWidget {
  final User user;

  const CustomDrawer({super.key, required this.user});

  // دالة لعرض تأكيد تسجيل الخروج بخطوتين
  void _showLogoutConfirmation(BuildContext context) {
    // الخطوة الأولى: تأكيد الخروج
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(a_logout_confirm_title),
        content: Text(a_logout_confirm_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(a_cancel, style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق مربع الحوار الحالي
              // عرض التأكيد الثاني
              _showFinalLogoutConfirmation(context);
            },
            child: Text(a_yes, style: style_text_button_normal_red),
          ),
        ],
      ),
    );
  }

  // دالة لعرض التأكيد النهائي لتسجيل الخروج
  void _showFinalLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(a_final_confirm_title),
        content: Text(a_logout_final_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(a_cancel, style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () async {
              // تنفيذ تسجيل الخروج
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // يمسح كل شي
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
              );
            },
            child: Text(a_confirm, style: style_text_button_normal_red),
          ),
        ],
      ),
    );
  }

  // دالة لعرض تأكيد الخروج من التطبيق بخطوتين
  void _showExitConfirmation(BuildContext context) {
    // الخطوة الأولى: تأكيد الخروج من التطبيق
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(a_exit_app_title),
        content: Text(a_exit_app_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(a_cancel, style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق مربع الحوار الحالي
              // عرض التأكيد الثاني
              _showFinalExitConfirmation(context);
            },
            child: Text(a_yes, style: style_text_button_normal_red),
          ),
        ],
      ),
    );
  }

  // دالة لعرض التأكيد النهائي للخروج من التطبيق
  void _showFinalExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(a_final_confirm_title),
        content: Text(a_exit_app_final_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(a_cancel, style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // إغلاق التطبيق
            },
            child: Text(a_exit, style: style_text_button_normal_red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: color_main,
      child: Column(
        children: [
          DrawerHeader(
            child: image_logo_w,
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: Text(a_main_page_d, style: drawerItemStyle),
            onTap: () {
              if (user.type == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPageAdmin(user: user)),
                );
              } else if (user.type == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPageUser(user: user)),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: Text(a_profile_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(user: user)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.white),
            title: Text(a_favort_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorite(user: user)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, color: Colors.white),
            title: const Text("نصيحة", style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Advice(user: user)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: Text(a_about_app_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => About(user: user)),
            ),
          ),
          const Divider(color: Colors.white54),
          ListTile(
            title: Text(a_logout_d, style: drawerItemStyle),
            onTap: () => _showLogoutConfirmation(context),
          ),
          ListTile(
            title: Text(a_app_out_d, style: drawerItemStyle),
            onTap: () => _showExitConfirmation(context),
          ),
        ],
      ),
    );
  }
}