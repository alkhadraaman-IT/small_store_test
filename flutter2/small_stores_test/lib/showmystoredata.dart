import 'package:flutter/material.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/models/storemodel.dart';
import 'package:small_stores_test/mystore.dart';
import 'package:small_stores_test/productall.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'showproductall.dart';
import 'showprofile.dart';
import 'showstore.dart';
import 'store.dart';
import 'variables.dart';
import 'style.dart';
import 'appbar.dart';

class ShowMyStoreData extends StatefulWidget {
  final StoreModel store;
  final User user;
  final bool page_view; // المتغير الجديد للتحكم في العرض

  const ShowMyStoreData({
    Key? key, required this.store, required this.user,this.page_view = true, // القيمة الافتراضية true
  }) : super(key: key);

  @override
  _ShowMyStoreData createState() => _ShowMyStoreData();
}

class _ShowMyStoreData extends State<ShowMyStoreData> {
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
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: a_show_store_t),
              Tab(text: a_show_product_t),
            ],
          ),
        ),
        drawer: CustomDrawer(user: widget.user,),
        body: TabBarView(
          children: widget.page_view
              ? [
            // الواجهات الافتراضية عندما يكون useDefaultView = true
            Store(store_id: widget.store.id,user: widget.user),
            ProductAll(store: widget.store,user: widget.user),
          ]
              : [
            // الواجهات البديلة عندما يكون useDefaultView = false
            ShowStore(store_id: widget.store.id),
            ShowProductAll(store: widget.store,user:widget.user,page_view: false,),
          ],
        ),
      ),
    );
  }
}