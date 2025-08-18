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
  final User user; // إضافة المتغير

  const CustomDrawer({super.key, required this.user});

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
            title: const Text(a_main_page_d, style: drawerItemStyle),
            onTap: () {
              if (user.type == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPageAdmin(user:user)),
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
            title: const Text(a_profile_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(user:user)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.white),
            title: const Text(a_favort_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorite(user:user)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, color: Colors.white),
            title: const Text("نصيحة", style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Advice(user:user)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text(a_about_app_d, style: drawerItemStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => About(user:user)),
            ),
          ),
          const Divider(color: Colors.white54),
          ListTile(
            title: const Text(a_logout_d, style: drawerItemStyle),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // يمسح كل شي
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
              );
            },

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