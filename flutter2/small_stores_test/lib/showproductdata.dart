import 'package:flutter/material.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/productall.dart';
import 'drawer.dart';
import 'product.dart';
import 'showproductall.dart';
import 'showprofile.dart';
import 'showstore.dart';
import 'store.dart';
import 'variables.dart';
import 'style.dart';
import 'appbar.dart';

class ShowProfileData extends StatefulWidget {
  @override
  _ShowProfileData createState() => _ShowProfileData();
}

class _ShowProfileData extends State<ShowProfileData> {
  final bool showBackButton=true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:Scaffold(
          appBar: AppBar(
            leading: showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
                : null,

            title: Text(app_name,style: style_name_app_o,),
            centerTitle: true,
            actions: [
              Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // فتح drawer باستخدام context الصحيح
                    },
                  )
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: a_user_data_t,),
                Tab(text: a_user_store_t,),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(
            children: [
              ShowProfile(),
              ProductAll(),
            ],
          ),
        )
    );
  }
}