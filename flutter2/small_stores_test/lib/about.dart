import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class About extends StatefulWidget {
  final User user; // إضافة المتغير

  const About({super.key, required this.user});

  @override
  _About createState() => _About();
}

class _About extends State<About> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user,),
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