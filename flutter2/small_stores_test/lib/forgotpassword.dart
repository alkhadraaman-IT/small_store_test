import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';
import 'dart:convert';

import 'chekpasswordcode.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController(text: "amanalkh727@gmail.com");


  final _formKey = GlobalKey<FormState>();

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleSendCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showError('يرجى إدخال البريد الإلكتروني');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/ForgotPassword?email=$email'),
      );



      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChekPasswordCode(email: email),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        showError(error["message"] ?? "البريد الإلكتروني غير موجود");
      }
    } catch (e) {
      showError('حدث خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app_name, style: style_name_app_o(color_main)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              image_restpassword,
              SizedBox(height: 16),
              Text("ادخل بريدك الإلكتروني لإرسال كود التحقق",style: style_text_titel,),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "البريد الإلكتروني",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3, // تلت عرض الشاشة
                child: ElevatedButton(
                  onPressed: _handleSendCode,
                  style: styleButton(color_main),
                  child: Text("إرسال"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
