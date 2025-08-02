import 'package:flutter/material.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/productall.dart';
import 'drawer.dart';
import 'product.dart';
import 'showproductall.dart';
import 'showstore.dart';
import 'store.dart';
import 'variables.dart';
import 'style.dart';
import 'appbar.dart';

class ShowStoreData extends StatefulWidget {
  @override
  _ShowStoreData createState() => _ShowStoreData();
}

class _ShowStoreData extends State<ShowStoreData> {
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
                Tab(text: a_show_store_t,),
                Tab(text: a_show_product_t,),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(
            children: [
              ShowStore(),
              ShowProductAll(),
            ],
          ),
        )
    );
  }
}