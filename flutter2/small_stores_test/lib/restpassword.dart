import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'mainpageuser.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class RestPassword extends StatefulWidget {
  final User user;

  RestPassword({required this.user});

  @override
  _RestPassword createState() => _RestPassword();
}

class _RestPassword extends State<RestPassword> {
  final TextEditingController _restPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _restPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app_name, style: style_name_app_o),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "تأكيد كلمة المرور",
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
                        return 'يرجى تأكيد كلمة المرور';
                      }
                      if (value != _restPasswordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3, // ثلث عرض الشاشة
                    child: ElevatedButton(
                      style: style_button,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final api = UserApi(apiService: ApiService(client: http.Client()));
                            final oldUser = await api.getUser(widget.user.id);

                            final updatedUser = User(
                              id: oldUser.id,
                              name: oldUser.name,
                              phone: oldUser.phone,
                              email: oldUser.email,
                              password: _restPasswordController.text,
                              profile_photo: oldUser.profile_photo,
                              type: oldUser.type,
                              status: oldUser.status,
                            );

                            await api.updateUser(widget.user.id, updatedUser);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPageUser(user: widget.user),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('فشل التحديث: $e')),
                            );
                          }
                        }
                      },
                      child: Text(a_add_b),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}