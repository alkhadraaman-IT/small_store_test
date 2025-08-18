import 'package:flutter/material.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:small_stores_test/style.dart';

import 'drawer.dart';
import 'models/usermodel.dart';
import 'myannouncement.dart';
import 'showmystore.dart' show ShowMyStore;
import 'showprofile.dart';
import 'variables.dart'; // تأكد من استيراد ملف الأنماط

class AnnouncementData extends StatefulWidget {
  final User user;

  const AnnouncementData({Key? key, required this.user}) : super(key: key);

  @override
  _AnnouncementData createState() => _AnnouncementData();
}

class _AnnouncementData extends State<AnnouncementData> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: tabBarDecoration, // من ملف الأنماط
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'كل الإعلانات'),
                Tab(text: 'إعلاناتي'),
              ],
              indicator: tabBarTheme.indicator,
              labelColor: tabBarTheme.labelColor,
              unselectedLabelColor: tabBarTheme.unselectedLabelColor,
              labelStyle: tabBarTheme.labelStyle,
              unselectedLabelStyle: tabBarTheme.unselectedLabelStyle,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AnnouncementScreen(user: widget.user),
                MyAnnouncement(user: widget.user),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
