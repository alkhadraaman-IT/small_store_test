import 'package:flutter/material.dart';
import 'package:small_stores_test/models/storemodel.dart';
import 'package:small_stores_test/productall.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'style.dart';
import 'variables.dart';

class ShowProductAll extends StatefulWidget {
  final StoreModel store;
  final User user;
  final int? favorite_id;
  final bool page_view; // المتغير الجديد للتحكم في العرض


  const ShowProductAll({Key? key, required this.store,required this.user,this.favorite_id,this.page_view = true,}) : super(key: key);
  @override
  _ShowProductAll createState() => _ShowProductAll();
}

class _ShowProductAll extends State<ShowProductAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: ProductAllBody(store: widget.store,user:widget.user,page_view: widget.page_view),
    );
  }
}