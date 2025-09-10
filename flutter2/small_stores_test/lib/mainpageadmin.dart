import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/home.dart';
import 'package:small_stores_test/mystore.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';
import 'announcementdata.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'profile.dart';
import 'statistics.dart';

class MainPageAdmin extends StatefulWidget {
  final User user;

  const MainPageAdmin({Key? key, required this.user}) : super(key: key);

  @override
  _MainPageAdmin createState() => _MainPageAdmin();
}

class _MainPageAdmin extends State<MainPageAdmin> {
  int _selectedIndex = 1; // الفهرس الافتراضي للصفحة

  // قائمة الصفحات المرتبطة بالرموز
  List<Widget> get _pages => [
    Statistics(),
    Home(user: widget.user),
    AnnouncementScreen(user: widget.user),
  ];
  final navigationKey = GlobalKey<CurvedNavigationBarState>();


  // قائمة الرموز في شريط التنقل السفلي
  final items = <Widget>[
    Icon(Icons.group, size: 30,color: Colors.white),
    Icon(Icons.home, size: 30,color: Colors.white,),
    Icon(Icons.campaign, size: 30,color: Colors.white),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // الشعار في اليسار (leading)
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/img_5.png',
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

      drawer: CustomDrawer(user: widget.user,),

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