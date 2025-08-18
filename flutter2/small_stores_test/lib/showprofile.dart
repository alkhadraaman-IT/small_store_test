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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: ProfileBody(user_id: widget.user.id),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('تأكيد الحذف'),
              content: Text('هل أنت متأكد أنك تريد حذف هذا المستخدم؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('إلغاء',style: style_text_button_normal,),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),style: style_button,
                  child: Text('حذف',),
                ),
              ],
            ),
          );

          if (confirm == true) {
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
        },
        child: Icon(Icons.delete, color: Colors.white),
        backgroundColor: color_main,
      ),

    );
  }
}