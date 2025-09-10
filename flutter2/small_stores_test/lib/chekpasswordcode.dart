import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:small_stores_test/restpassword.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

class ChekPasswordCode extends StatefulWidget {
  final String email;
  ChekPasswordCode({required this.email});

  @override
  _ChekPasswordCode createState() => _ChekPasswordCode();
}

class _ChekPasswordCode extends State<ChekPasswordCode> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      showError("يرجى إدخال كود التحقق");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/CheckCode'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': widget.email,
          'code': _codeController.text.trim(),
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html>')) {
        showError("حدث خطأ في الخادم (صفحة HTML)");
        return;
      }

      final responseData = jsonDecode(response.body);
      print('Response Data: $responseData');

      if (response.statusCode == 200) {
        showSuccess("تم التحقق بنجاح");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: widget.email),
          ),
        );
      } else if (response.statusCode == 401) {
        showError(responseData['message'] ?? "كود التحقق غير صحيح");
      } else if (response.statusCode == 422) {
        showError(responseData['message'] ?? "بيانات غير صحيحة (خطأ 422)");
        print('=== تفاصيل خطأ 422 ===');
        print('Email sent: ${widget.email}');
        print('Code sent: ${_codeController.text.trim()}');
        print('======================');
      } else {
        showError("حدث خطأ: ${responseData['message'] ?? response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      if (e is FormatException) {
        showError("الخادم يعيد بيانات غير صحيحة");
      } else {
        showError("خطأ في الاتصال: $e");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image_restpassword,
            SizedBox(height: 24),
            Text(
              "ادخل الكود المرسل إلى",
              style: style_text_titel
            ),
            SizedBox(height: 8),
            Text(
              widget.email,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color_main,
              ),
            ),
            SizedBox(height: 16),
            // جملة "تحقق من البريد" فوق مربع الإدخال
            Text(
              "تحقق من بريدك الإلكتروني للحصول على كود التحقق",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // مربع إدخال الكود بسيط
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "كود التحقق",
                prefixIcon: Icon(Icons.verified_user_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
               // hintText: "ادخل الرمز المكون من 5 أرقام",
              ),
              keyboardType: TextInputType.number,
              maxLength: 5,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            // الزر كما كان
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
                style: styleButton(color_main),
                child: _isLoading
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8),
                   // Text("جاري التحقق..."),
                  ],
                )
                    : Text("تأكيد الكود"),
              ),
            )
          ],
        ),
      ),
    );
  }
}