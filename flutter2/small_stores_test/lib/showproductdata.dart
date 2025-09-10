import 'package:flutter/material.dart';
import 'package:small_stores_test/style.dart';

import 'drawer.dart';
import 'models/usermodel.dart';
import 'showmystore.dart' show ShowMyStore;
import 'showprofile.dart';
import 'variables.dart'; // تأكد من استيراد ملف الأنماط

class ShowProfileData extends StatefulWidget {
  final User user;

  const ShowProfileData({Key? key, required this.user}) : super(key: key);

  @override
  _ShowProfileData createState() => _ShowProfileData();
}

class _ShowProfileData extends State<ShowProfileData> {
  final bool showBackButton = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: showBackButton
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          )
              : null,
          title: Text(app_name, style: style_name_app_o(color_main)),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Container(
              decoration: tabBarDecoration, // استخدم التصميم من ملف الأنماط
              child: TabBar(
                tabs: [
                  Tab(text: a_user_data_t),
                  Tab(text: a_user_store_t),
                ],/*
                indicator: tabBarTheme.indicator, // مؤشر من الأنماط
                labelColor: tabBarTheme.labelColor,
                unselectedLabelColor: tabBarTheme.unselectedLabelColor,
                labelStyle: tabBarTheme.labelStyle,
                unselectedLabelStyle: tabBarTheme.unselectedLabelStyle,*/
              ),
            ),
          ),
        ),
        drawer: CustomDrawer(user: widget.user),
        body: TabBarView(
          children: [
            ShowProfile(user: widget.user),
            ShowMyStore(user: widget.user),
          ],
        ),
      ),
    );
  }
}