import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:small_stores_test/about.dart';
import 'package:small_stores_test/favorite.dart';
import 'package:small_stores_test/login.dart';
import 'package:small_stores_test/mainpageadmin.dart';
import 'package:small_stores_test/profile.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

import 'announcement.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: color_main,
      child: Column(
        children: [
          DrawerHeader(
            child: image_logo_s,
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text(a_main_page_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPageUser()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text(a_profile_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.white),
            title: const Text(a_favort_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorite()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text(a_about_app_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => About()),
            ),
          ),
          const Divider(color: Colors.white54),
          ListTile(
            title: const Text(a_logout_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            ),
          ),
          ListTile(
            title: const Text(a_app_out_d, style: drawerItemStyle),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('تأكيد الخروج'),
                  content: Text('هل أنت متأكد أنك تريد الخروج من التطبيق؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // إلغاء
                      child: Text('إلغاء',style: style_text_button_normal,),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop(); // ✅ إغلاق التطبيق
                      },
                      child: Text('خروج',style: style_text_button_normal,),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}