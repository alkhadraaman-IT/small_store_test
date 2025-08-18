import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'package:small_stores_test/createuser.dart';
import 'package:small_stores_test/forgotpassword.dart';
import 'package:small_stores_test/home.dart';
import 'package:small_stores_test/mainpageuser.dart';
import 'package:small_stores_test/variables.dart';

import 'apiService/auth_service_api.dart';
import 'mainpageadmin.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                            SizedBox(height: 8),
                            Text(a_login_b,style: style_text_titel),
                            SizedBox(height: 10),
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
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: _authenticate,
                                  child: Text(a_reset_password_b, style: style_text_button_normal, textDirection: TextDirection.rtl),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text("نغير كلمة المرور باستخدام البريد الإلكتروني", style: style_text_button_normal, textDirection: TextDirection.rtl),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: style_button,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final result = await AuthService.login(
                                      _emailController.text.trim(),
                                      _passWordController.text.trim(),
                                    );

                                    // التأكد من وجود المستخدم في الاستجابة
                                    if (result.containsKey('user')) {
                                      final user = User.fromJson(result['user']);

                                      // الانتقال للواجهة الرئيسية مع تمرير الـ ID
                                      if (user.type == 0) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MainPageAdmin(user: user),
                                          ),
                                        );
                                      } else if (user.type == 1) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MainPageUser(user: user),
                                          ),
                                        );
                                      } else {
                                        // لو في نوع آخر تقدر تتعامل معه أو تعطي رسالة خطأ
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('نوع المستخدم غير معروف')),
                                        );
                                      }

                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('بيانات تسجيل الدخول غير صحيحة')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('فشل تسجيل الدخول: $e')),
                                    );
                                  }
                                }
                              },
                              child: Text(a_login_b),
                            ),

                            SizedBox(height: 16,),
                            Text(a_createuser_q_s,style: style_text_normal),
                            SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextButton(
                                onPressed: () async {
                                  final result = await AuthService.login(
                                    _emailController.text.trim(),
                                    _passWordController.text.trim(),
                                  );

                                  if (result.containsKey('user')) {
                                    final user = User.fromJson(result['user']);

                                    // ⬅️ خزّن التوكن + كل معلومات المستخدم
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('token', result['token']);
                                    await prefs.setInt('userId', user.id);
                                    await prefs.setString('userName', user.name);
                                    await prefs.setString('userPhone', user.phone);
                                    await prefs.setString('userEmail', user.email);
                                    await prefs.setString('userPassword', user.password ?? "");
                                    await prefs.setString('userPhoto', user.profile_photo ?? image_user_path);
                                    await prefs.setInt('userType', user.type);
                                    await prefs.setInt('userStatus', user.status);

                                    // روح على الصفحة المناسبة
                                    if (user.type == 0) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MainPageAdmin(user: user)),
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MainPageUser(user: user)),
                                      );
                                    }
                                  }

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

