import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/editprofile.dart';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // اختياري
      drawer: CustomDrawer(), // اختياري
      body: SingleChildScrollView(
        child: Center(
          child: ProfileBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfile()),
          );
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userApi = UserApi(apiService: ApiService(client: http.Client()));
      final userId = 1; //  استبدل هذا بالـ ID الحقيقي من الجلسة أو Auth
      final fetchedUser = await userApi.getUser(userId);

      setState(() {
        _user = fetchedUser;
        _isLoading = false;
      });
    } catch (e) {
      print(' خطأ في جلب بيانات المستخدم: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // لمحاذاة لليمين
        children: [
          Image.asset(
            _user.profile_photo ?? 'assets/images/img_3.png',
            width: 100,
            height: 100,
          ),
          SizedBox(height: 16),
          Text(
            '$a_user_name_s: ${_user.name}',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          Text(
            '$a_user_email_s: ${_user.email}',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          Text(
            '$a_user_phone_s: ${_user.phone}',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          /*Text(//مكان السكن
            '$a_user_plan_s: $note',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),*/
        ],
      ),
    );
  }
}
