import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'mainpageuser.dart';
import 'style.dart';
import 'variables.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUser createState() => _CreateUser();
}

class _CreateUser extends State<CreateUser> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _planController = TextEditingController();

  bool isPasswordVisible = false;
  bool _isFingerprintAdded = false;
  File? _fingerprintImage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _phoneController.dispose();
    _planController.dispose();
    super.dispose();
  }

  Future<void> _addFingerprint() async {
    try {
      // 1. التحقق من توفر البصمة على الجهاز
      final bool canAuthenticate = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('جهازك لا يدعم المصادقة بالبصمة')),
        );
        return;
      }

      // 2. التقاط صورة للبصمة (اختياري)
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _fingerprintImage = File(pickedImage.path);
        });
      }

      // 3. طلب المصادقة بالبصمة
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'المس مستشعر البصمة للتسجيل',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        setState(() {
          _isFingerprintAdded = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تسجيل البصمة بنجاح')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
    }
  }

  bool _isLoading = false; // لإظهار مؤشر التحميل
  final ApiService apiService = ApiService(client: http.Client());
  late UserApi userApi;
  @override
  void initState() {
    super.initState();
    userApi = UserApi(apiService: apiService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(app_name, style: style_name_app_o),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  image_login,
                  SizedBox(height: 16),
                  Text(app_name, style: style_name_app_o),
                  SizedBox(height: 16),
                  Text(a_createuser_s, style: style_text_titel),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: a_first_name_l,
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25), // تحديد عدد المحارف
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')), // يمنع الأرقام
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_first_name_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: a_last_name_l,
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25), // تحديد عدد المحارف
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')), // يمنع الأرقام
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_last_name_m;
                      }
                      return null;
                    },
                  ),
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
                      prefixIcon: Icon(Icons.lock_open),
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
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: a_phone_l,
                      prefixIcon: Icon(Icons.phone),
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '+963',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9), // 9 خانات فقط بعد +963
                      FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')), // يمنع الحروف
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_phone_m;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),
                  /*TextFormField(
                    controller: _planController,
                    decoration: InputDecoration(
                      labelText: a_plan_l,
                      prefixIcon: Icon(Icons.place),
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25), // تحديد عدد المحارف
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_plan_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
*/
                  // قسم إضافة البصمة
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'إضافة البصمة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color_main,
                            ),
                          ),
                          SizedBox(height: 12),
                          _fingerprintImage != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_fingerprintImage!, height: 100),
                          )
                              : Icon(Icons.fingerprint, size: 50, color: color_main),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: style_button,
                            onPressed: _addFingerprint,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isFingerprintAdded ? Icons.check_circle : Icons.fingerprint,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _isFingerprintAdded ? 'تمت إضافة البصمة' : 'إضافة بصمة',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child:ElevatedButton(
                      style: style_button,
                      onPressed: () async  {
                        if (_formKey.currentState!.validate()) {
                          /*if (!_isFingerprintAdded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('الرجاء إضافة البصمة أولاً')),
                            );
                            return;
                          }*/
                          setState(() => _isLoading = true);
                          try {
                            final newUser  = await userApi.addUser(
                              name: '${_firstNameController.text} ${_lastNameController.text}',
                              email: _emailController.text,
                              password: _passWordController.text,
                              phone: _phoneController.text,
                            );
                            print('dataaaaaaaaaaaaaaa:');
                            print(newUser.toJson());

                            final int user_id = newUser.id;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
                            );
                            print(newUser.toJson());

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainPageUser(user: newUser)),
                            );} catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('فشل في إنشاء الحساب: ${e.toString()}')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(a_login_b),
                    ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}