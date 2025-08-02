import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'package:small_stores_test/createuser.dart';
import 'package:small_stores_test/home.dart';
import 'package:small_stores_test/mainpageuser.dart';
import 'package:small_stores_test/variables.dart';

import 'style.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();

  bool isPasswordVisible=false;
  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  //البصمة
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      bool canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('البصمة غير مدعومة على هذا الجهاز')),
        );
        return;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'سجّل الدخول باستخدام البصمة', // رسالة تظهر للمستخدم
        options: const AuthenticationOptions(
          biometricOnly: true, // يطلب البصمة فقط (ليس PIN)
        ),
      );

      if (authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم المصادقة بنجاح! ')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشلت المصادقة ')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(app_name,style: style_name_app_o,),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form( // ✅ إحاطة النموذج بـ Form
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          children: [
                            image_login,
                            //SizedBox(height: 16),
                            //Text(app_name,style:style_name_app_o),
                            SizedBox(height: 16),
                            Text(a_login_b,style: style_text_titel),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: a_email_l,
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return a_email_m;
                                }
                                if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                                  return 'البريد الإلكتروني غير صالح';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _passWordController,
                              decoration: InputDecoration(
                                labelText: a_password_l,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible ? Icons.remove_red_eye : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !isPasswordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return a_password_m;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(a_reset_password_l),
                                ),
                                TextButton(
                                  onPressed: _authenticate,
                                  child: Text(a_reset_password_b, style: style_text_button_normal, textDirection: TextDirection.rtl),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                                style: style_button,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MainPageUser()),
                                    );
                                  }
                                },
                                child: Text(a_login_b)),
                            SizedBox(height: 16,),
                            Text(a_createuser_q_s,style: style_text_normal),
                            SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CreateUser()),
                                  );
                                },
                                child: Text(
                                  a_createuser_b,
                                  style: style_text_button_normal,
                                ),
                              ),
                            )
                          ]
                      ),
                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
}

