import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'store.dart';


class ShowStore extends StatefulWidget {
  @override
  _ShowStore createState() => _ShowStore();
}

class _ShowStore extends State<ShowStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: StoreBody(),
    );
  }
}