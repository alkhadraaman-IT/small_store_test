import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/home.dart';
import 'package:small_stores_test/mystore.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';
import 'drawer.dart';
import 'profile.dart';

class MainPageUser extends StatefulWidget {
  @override
  _MainPageUser createState() => _MainPageUser();
}

class _MainPageUser extends State<MainPageUser> {
  int _selectedIndex = 1; // الفهرس الافتراضي للصفحة

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  // قائمة الرموز في شريط التنقل السفلي
  final items = <Widget>[
    Icon(Icons.storefront_rounded, size: 30,color: Colors.white),
    Icon(Icons.home, size: 30,color: Colors.white,),
    Icon(Icons.campaign, size: 30,color: Colors.white),
  ];

  // قائمة الصفحات المرتبطة بالرموز
  final List<Widget> _pages = [
    MyStore(),
    Home(),
    Announcement(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // الشعار في اليسار (leading)
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/img_1.png',
            height: 32,
            width: 32,
          ),
        ),

        // عنوان التطبيق
        title: Text(
          app_name,
          style: TextStyle(
            color: color_main,
          ),
        ),
        centerTitle: true,

        // أيقونة القائمة في اليمين (actions)
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),


      drawer: CustomDrawer(),

      body: _pages[_selectedIndex], // عرض الصفحة الحالية بناءً على الفهرس

      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        backgroundColor: Colors.transparent, // خلفية الشريط
        color: color_main,
        buttonBackgroundColor: color_main, // لون الزر المحدد
        height: 60, // ارتفاع الشريط
        index: _selectedIndex, // الفهرس الحالي
        items: items, // الرموز في الشريط
        animationCurve: Curves.easeInOut, // منحنى الحركة
        animationDuration: const Duration(milliseconds: 300), // مدة الحركة
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // تحديث الفهرس عند النقر
          });
        },
      ),
    );
  }
}