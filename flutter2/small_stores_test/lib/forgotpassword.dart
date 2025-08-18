import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';
import 'dart:math';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'chekpasswordcode.dart';
import 'models/usermodel.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? sentCode; // لتخزين كود التحقق المرسل
  int? user_id;
  User? user;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String generateVerificationCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString(); // 4 digits
  }

  Future<void> _handleSendCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showError('يرجى إدخال البريد الإلكتروني');
      return;
    }

    try {
      final api = UserApi(apiService: ApiService(client: http.Client()));
      final users = await api.getUsers();

      User? user;

      for (var u in users) {
        if (u.email.toLowerCase() == email.toLowerCase()) {
          user = u;
          break;
        }
      }

      if (user != null) {
        // توليد كود التحقق
        sentCode = generateVerificationCode();
        print('Verification cooooode sent to user: $sentCode');

        user_id = user.id;

        // هنا يمكنك إرسال الكود عبر الإيميل باستخدام API خاص بالرسائل أو SMTP (غير مدمج بالكود الحالي)
        // لكن الآن سنعرض صفحة إدخال الكود فقط

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCodePage(
              sentCode: sentCode!,
              user_id: user_id!,
              user: user!,
            ),
          ),
        );
      } else {
        showError('هذا البريد غير موجود');
      }
    } catch (e) {
      showError('حدث خطأ أثناء التحقق: $e');
    }
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              image_login,
              SizedBox(height: 16),
              Text("نسيت كلمة المرور",style: style_text_titel,),
              SizedBox(height: 16),
              Text(
                "أدخل بريدك الإلكتروني لاستعادة كلمة المرور",
                style: style_text_normal,
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
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                    return 'بريد إلكتروني غير صالح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3, // ثلث عرض الشاشة
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleSendCode();
                    }
                  },
                  style: style_button,
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