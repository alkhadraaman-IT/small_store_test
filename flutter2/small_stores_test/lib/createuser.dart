import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'mainpageuser.dart';
import 'style.dart';
import 'variables.dart';
import 'models/usermodel.dart'; // تأكد من استيراد نموذج User

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

  bool isPasswordVisible = false;
  bool _isFingerprintAdded = false;
  File? _fingerprintImage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ApiService apiService = ApiService(client: http.Client());
  late UserApi userApi;

  @override
  void initState() {
    super.initState();
    userApi = UserApi(apiService: apiService);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // دالة لحفظ بيانات المستخدم في الذاكرة المحلية
  Future<void> _saveUserData(User user, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('user_id', user.id);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_phone', user.phone);
      await prefs.setString('user_token', token);

      print('تم حفظ بيانات المستخدم في الذاكرة المحلية');
    } catch (e) {
      print('خطأ في حفظ البيانات: $e');
      throw Exception('فشل في حفظ بيانات المستخدم محلياً');
    }
  }

  Future<void> _addFingerprint() async {
    try {
      final bool canAuthenticate = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('جهازك لا يدعم المصادقة بالبصمة')),
        );
        return;
      }

      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _fingerprintImage = File(pickedImage.path);
        });
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(app_name, style: style_name_app_o(color_main)),
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
                      LengthLimitingTextInputFormatter(25),
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
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
                      LengthLimitingTextInputFormatter(25),
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
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
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long'; // رسالة خطأ إذا كانت كلمة المرور أقل من 8 أحرف
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
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_phone_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // قسم إضافة البصمة
                 /* Card(
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
                  ),*/
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: styleButton(color_main),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        try {
                          final result = await userApi.addUser(
                            name: '${_firstNameController.text} ${_lastNameController.text}',
                            email: _emailController.text,
                            password: _passWordController.text,
                            phone: _phoneController.text,
                          );

                          if (result.containsKey('user') && result.containsKey('access_token')) {
                            final user = User.fromJson(result['user']);
                            final userToken = result['access_token'];

                            // حفظ البيانات في الذاكرة المحلية
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('access_token', userToken);
                            await prefs.setInt('userId', user.id);
                            await prefs.setString('userName', user.name);
                            await prefs.setString('userPhone', user.phone);
                            await prefs.setString('userEmail', user.email);
                            await prefs.setString('userPassword', _passWordController.text);
                            await prefs.setString('userPhoto', user.profile_photo ?? image_user_path);
                            await prefs.setInt('userType', user.type);
                            await prefs.setInt('userStatus', user.status);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainPageUser(user: user)),
                            );
                          }
                        } catch (e) {
                          // عرض تفاصيل الخطأ بشكل أوضح
                          String errorMessage = 'فشل في إنشاء الحساب';

                          if (e.toString().contains('email') || e.toString().contains('Email')) {
                            errorMessage = 'البريد الإلكتروني مستخدم مسبقاً';
                          } else if (e.toString().contains('phone') || e.toString().contains('Phone')) {
                            errorMessage = 'رقم الهاتف مستخدم مسبقاً';
                          } else if (e.toString().contains('422')) {
                            errorMessage = 'البيانات غير صحيحة أو ناقصة';
                          } else {
                            errorMessage = e.toString();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );

                          print('تفاصيل الخطأ الكاملة: $e');
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(a_login_b),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}