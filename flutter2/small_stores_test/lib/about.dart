import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class About extends StatefulWidget {
  @override
  _About createState() => _About();
}

class _About extends State<About> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              image_logo_b,
              SizedBox(height: 16),
              Text(a_app_note_s,style: style_text_titel),
              SizedBox(height: 16),
              Text(a_not_s,style: style_text_normal,),
            ],
          ),
        ),)
      ),
    );
  }
}