import 'package:flutter/material.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class RestPassword extends StatefulWidget {
  @override
  _RestPassword createState() => _RestPassword();
}

class _RestPassword extends State<RestPassword> {
  final TextEditingController _restPasswordController = TextEditingController();
  bool isPasswordVisible1=false;
  bool isPasswordVisible2=false;

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  @override
  void dispose() {
    _restPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form( // ✅ إحاطة النموذج بـ Form
                  key: _formKey,
                  child: Column(
                      children: [
                        image_login,
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _restPasswordController,
                          decoration: InputDecoration(
                            labelText: a_password_l,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible1 ? Icons.remove_red_eye : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible1 = !isPasswordVisible1;
                                });
                              },
                            ),
                          ),
                          obscureText: !isPasswordVisible1,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return a_password_m;
                            }
                            return null;
                          },
                        ),SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: a_password_l,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible2 ? Icons.remove_red_eye : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible2 = !isPasswordVisible2;
                                });
                              },
                            ),
                          ),
                          obscureText: !isPasswordVisible2,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return a_password_m;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(style: style_button,onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Announcement()),
                            );
                          }
                        }, child: Text(a_add_b)),
                        SizedBox(height: 16),

                      ]

                  ),
                ),
              ),
            )
        )
    );
  }
}