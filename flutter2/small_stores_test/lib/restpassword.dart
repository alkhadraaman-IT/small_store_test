import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      print('فات');
      try {
        // طباعة البيانات المرسلة
        print('Emailllll: ${widget.email}');
        print('Passwordddddd: ${_passwordController.text}');
        print('Confirmationnnnnnnn: ${_confirmController.text}');

        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/ChangePassword'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': widget.email,
            'password': _passwordController.text,
            'passwordRet': _confirmController.text,
          }),
        );
        if (response == null) {
          return;
        }

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.body.startsWith('<!DOCTYPE') || response.body.startsWith('<html>')) {
          showError("حدث خطأ في الخادم (صفحة HTML)");
          return;
        }

        if (response.statusCode == 200) {
          Navigator.popUntil(context, (route) => route.isFirst);
          showError("تم تغيير كلمة المرور بنجاح");
        } else {
          Map<String, dynamic> errorBody = jsonDecode(response.body);
          showError(errorBody['message'] ?? "فشل تغيير كلمة المرور");
        }
      } catch (e) {
        showError("خطأ: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(app_name,style: style_name_app_o(color_main),),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              image_restpassword,
              SizedBox(height: 16),
              Text("تعين كلمة المرور الجديدة",style: style_text_titel,),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "كلمة المرور الجديدة",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isPasswordVisible1 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible1 = !isPasswordVisible1;
                      });
                    },
                  ),
                ),
                obscureText: !isPasswordVisible1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى إدخال كلمة المرور";
                  }
                  if (value.length < 8) {
                    return 'يجب ان تكون كلمة السر أكثر من 8 محارف'; // رسالة خطأ إذا كانت كلمة المرور أقل من 8 أحرف
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmController,
                decoration: InputDecoration(
                  labelText: "تأكيد كلمة المرور",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isPasswordVisible2 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible2 = !isPasswordVisible2;
                      });
                    },
                  ),
                ),
                obscureText: !isPasswordVisible2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى تأكيد كلمة المرور";
                  }
                  if (value != _passwordController.text) {
                    return "كلمتا المرور غير متطابقتين";
                  }
                  if (value.length < 8) {
                    return 'يجب أن تكون كلمة السر أكثر من 8 محارف'; // رسالة خطأ إذا كانت كلمة المرور أقل من 8 أحرف
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3, // تلت عرض الشاشة
            child:ElevatedButton(
                onPressed: _resetPassword,
                style: styleButton(color_main),
                child: Text("تغيير"),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
