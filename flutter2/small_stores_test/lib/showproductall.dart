import 'package:flutter/material.dart';
import 'package:small_stores_test/productall.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'product.dart';
import 'style.dart';
import 'variables.dart';

class ShowProductAll extends StatefulWidget {
  @override
  _ShowProductAll createState() => _ShowProductAll();
}

class _ShowProductAll extends State<ShowProductAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: ProductAllBody(),
    );
  }
}