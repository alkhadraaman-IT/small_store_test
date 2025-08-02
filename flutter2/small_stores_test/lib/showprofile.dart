import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'product.dart';
import 'profile.dart';
import 'style.dart';
import 'variables.dart';

class ShowProfile extends StatefulWidget {
  @override
  _ShowProfile createState() => _ShowProfile();
}

class _ShowProfile extends State<ShowProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: ProfileBody(),
    );
  }
}