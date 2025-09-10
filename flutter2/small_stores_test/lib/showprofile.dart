import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/statistics.dart';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'profile.dart';
import 'style.dart';
import 'variables.dart';

class ShowProfile extends StatefulWidget {
  final User user;

  const ShowProfile({Key? key, required this.user}) : super(key: key);

  @override
  _ShowProfile createState() => _ShowProfile();
}

class _ShowProfile extends State<ShowProfile> {
  // دالة لعرض تأكيد الحذف بخطوتين
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // الخطوة الأولى: تأكيد الحذف
    bool? firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تأكيد الحذف', style: style_text_titel),
        content: Text('هل تريد حذف هذا المستخدم؟', style: style_text_normal),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('إلغاء', style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('نعم', style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (firstConfirm == true) {
      // الخطوة الثانية: التأكيد النهائي
      bool? finalConfirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('تأكيد نهائي', style: style_text_titel),
          content: Text('هل أنت متأكد من أنك تريد حذف هذا المستخدم؟ لا يمكن التراجع عن هذه العملية.', style: style_text_normal),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('إلغاء', style: style_text_button_normal_2(color_Secondary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('تأكيد الحذف', style: style_text_button_normal_red),
            ),
          ],
        ),
      );

      if (finalConfirm == true) {
        _deleteUser();
      }
    }
  }

  // دالة حذف المستخدم
  Future<void> _deleteUser() async {
    try {
      final api = UserApi(apiService: ApiService(client: http.Client()));
      await api.deleteUser(widget.user.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف المستخدم بنجاح')),
      );

      Navigator.pop(context); // الرجوع بعد الحذف
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف المستخدم: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBody(user_id: widget.user.id),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeleteConfirmation(context),
        child: Icon(Icons.delete, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}