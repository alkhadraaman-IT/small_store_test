import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'showstoredata.dart';
import 'style.dart';
import 'variables.dart';

class Announcement extends StatefulWidget {
  @override
  _Announcement createState() => _Announcement();
}

class _Announcement extends State<Announcement> {
  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ لجعل العنوان على اليمين
          children: [
            Text(
              a_ann_d,
              style: style_text_titel,
              textAlign: TextAlign.right, // ✅ العنوان لليمين
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // عدّل حسب عدد الإعلانات
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // الخلفية - صورة مع تدرج
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/store_bg.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // المحتوى في الأسفل
                        Positioned(
                          bottom: 12,
                          right: 12,
                          left: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // ✅ كل النصوص لليمين
                            children: [
                              Directionality( // ✅ لعكس اتجاه صف الشعار واسم المتجر
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ShowStoreData()),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage('assets/images/logo.png'),
                                        radius: 16,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'اسم المتجر',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'هذا هو نص الإعلان المميز الخاص بالمتجر.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right, // ✅ نص الإعلان لليمين
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
