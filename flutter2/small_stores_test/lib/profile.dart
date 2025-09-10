import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/editprofile.dart';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'main.dart';
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

  final List<Color> colors = [
    Color(0xFFFFBC04), // برتقالي
    Color(0xFF073934),
    Colors.pink,
    Colors.grey,
    Colors.black,
    Color(0xFFC3FBBB),
    Color(0xFFFDA0E0),
    Color(0xFF9F5F8E),
    Color(0xFF088C91),
  ];
  @override
  void initState() {
    super.initState();
    loadColor().then((_) {
      setState(() {}); // لتحديث الواجهة بعد تحميل اللون
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // اختياري
      drawer: CustomDrawer(user: widget.user,), // اختياري
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
           ProfileBody(
            user_id: widget.user.id, // ✅ مرر اليوزر آي دي
            onUserLoaded: (user) {
              setState(() {
                _user = user;
              });
            },
          ),
              Text('لون التطبيق', style: style_text_titel),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1, // يخلي كل خانة مربعة
                children: colors.map((c) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        color_main = c;
                        saveColor(c);
                      });
                      (context.findAncestorStateOfType<MyAppState>())?.updateTheme();
                    },
                    child: Center( // يحافظ على الحجم
                      child: Container(
                        width: 60,   // حجم ثابت
                        height: 60,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color_main == c ? color_Secondary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            ])),
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
      final fetchedUser = await userApi.getUser(widget.user_id);

      setState(() {
        _user = fetchedUser;
        _isLoading = false;
      });

      if (widget.onUserLoaded != null) {
        widget.onUserLoaded!(_user);
      }
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات المستخدم كما عندك
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: _user.profile_photo != null && _user.profile_photo!.isNotEmpty
                  ? NetworkImage(_user.profile_photo!)
                  : AssetImage('assets/images/img_3.png') as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 32),
          Text('الاسم: ${_user.name}', style: style_text_normal, textAlign: TextAlign.right),
          SizedBox(height: 16),
          Text('البريد: ${_user.email}', style: style_text_normal, textAlign: TextAlign.right),
          SizedBox(height: 16),
          Text('الهاتف: ${_user.phone}', style: style_text_normal, textAlign: TextAlign.right),
          SizedBox(height: 32),

          // هنا نضيف اختيار اللون

        ],
      ),
    );
  }
}