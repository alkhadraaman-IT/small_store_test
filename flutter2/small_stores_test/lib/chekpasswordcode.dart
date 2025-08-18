import 'package:flutter/material.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

import 'models/usermodel.dart';
import 'restpassword.dart';

class VerifyCodePage extends StatefulWidget {
  final String sentCode;
  final int user_id;
  final User user;

  VerifyCodePage({required this.sentCode, required this.user_id, required this.user});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _codeController = TextEditingController();

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        child: Column(
          children: [
            Text("تحقق من الكود", style: style_text_titel),
            SizedBox(height: 16),
            Text(
              "أدخل كود التحقق المرسل إلى بريدك الإلكتروني",
              style: style_text_normal,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "كود التحقق",
                prefixIcon: Icon(Icons.verified),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3, // ثلث عرض الشاشة
              child: ElevatedButton(
                onPressed: () {
                  if (_codeController.text.trim() == widget.sentCode) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestPassword(user: widget.user),
                      ),
                    );
                  } else {
                    showError("كود التحقق غير صحيح");
                  }
                },
                style: style_button,
                child: Text("تأكيد"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}