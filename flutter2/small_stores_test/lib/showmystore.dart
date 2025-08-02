import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'mystore.dart';


class ShowMyStore extends StatefulWidget {
  @override
  _ShowMyStore createState() => _ShowMyStore();
}

class _ShowMyStore extends State<ShowMyStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: MyStoreBody(),
    );
  }
}