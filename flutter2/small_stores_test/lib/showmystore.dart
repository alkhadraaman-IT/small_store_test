import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'mystore.dart';


class ShowMyStore extends StatefulWidget {
  final User user;

  const ShowMyStore({Key? key, required this.user}) : super(key: key);

  @override
  _ShowMyStore createState() => _ShowMyStore();
}

class _ShowMyStore extends State<ShowMyStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: MyStoreBody(user: widget.user,page_view: false,),
    );
  }
}