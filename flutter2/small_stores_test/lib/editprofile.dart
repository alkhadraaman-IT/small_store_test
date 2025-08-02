import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:small_stores_test/profile.dart';
import 'package:image_picker/image_picker.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'mainpageuser.dart';
import 'style.dart';
import 'variables.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _planController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoController.text = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _phoneController.dispose();
    _planController.dispose();
    _photoController.dispose();
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
                Text(a_edit_profile_s,style: style_text_titel),
                SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: a_first_name_l,
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.name,
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
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
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
     /* SizedBox(height: 16),
                TextFormField(
                  controller: _planController,
                  decoration: InputDecoration(
                    labelText: a_plan_l,
                    prefixIcon: Icon(Icons.place),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return a_plan_m;
                    }
                    return null;
                  },
                ),*/
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(  // <<=== هذا هو المفتاح
                      child: TextFormField(
                        controller: _photoController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: a_store_class_s,
                          prefixIcon: Icon(Icons.image),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return a_store_logo_m;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: style_button,
                      onPressed: _pickImage,
                      child: Text(a_add_b),
                    ),
                  ],
                ),
                SizedBox(height: 16),
    SizedBox(
    width: MediaQuery.of(context).size.width / 3,
    child: ElevatedButton(style: style_button,onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }
                }, child: Text(a_edit_b))),
                SizedBox(height: 16),
              ]
          ),
        ),
      )
    ),
    )
    );
  }
}