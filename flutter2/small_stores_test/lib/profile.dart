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
  final User user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // اختياري
      drawer: CustomDrawer(user: widget.user,), // اختياري
      body: SingleChildScrollView(
        child: Center(
          child: ProfileBody(
            user_id: widget.user.id, // ✅ مرر اليوزر آي دي
            onUserLoaded: (user) {
              setState(() {
                _user = user;
              });
            },
          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(user: _user!), // ✅ مرر المستخدم
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('جاري تحميل البيانات...')),
            );
          }
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  final Function(User)? onUserLoaded;
  final int user_id;


  ProfileBody({this.onUserLoaded, required this.user_id});

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
      final user_id = widget.user_id; // ✅ استخدم ID الممرر
      final fetchedUser = await userApi.getUser(user_id);

      setState(() {
        _user = fetchedUser;
        _isLoading = false;
      });

      // ✅ أرسل بيانات المستخدم إلى الأب (Profile)
      if (widget.onUserLoaded != null) {
        widget.onUserLoaded!(_user);
      }

    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
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
        crossAxisAlignment: CrossAxisAlignment.start, // لمحاذاة لليمين
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // عدّل الرقم لتكبير/تصغير الزوايا
            child: Image.asset(
              _user.profile_photo ?? 'assets/images/img_3.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover, // عشان الصورة تعبي الـ container
            ),
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
