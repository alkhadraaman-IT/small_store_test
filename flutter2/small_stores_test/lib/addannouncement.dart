import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/announcement.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'apiService/announcement_api.dart';
import 'apiService/api_service.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class AddAnnouncement extends StatefulWidget {
  @override
  _AddAnnouncement createState() => _AddAnnouncement();
}

class _AddAnnouncement extends State<AddAnnouncement> {
  final TextEditingController _announcementNoteController = TextEditingController();
  final TextEditingController _announcementImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form


  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _announcementImageController.text = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    _announcementNoteController.dispose();
    _announcementImageController.dispose();
    super.dispose();
  }

  File? _selectedImage;
  bool _isLoading = false;
  late final AnnouncementApi announcementApi;

  @override
  void initState() {
    super.initState();
    announcementApi = AnnouncementApi(apiService: ApiService(client: http.Client()));
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
                      Text(a_AddAnnouncement_s,style: style_text_titel),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _announcementNoteController,
                        decoration: InputDecoration(
                          labelText: a_text_Announcement_l,
                          prefixIcon: Icon(Icons.sticky_note_2_rounded),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return a_store_name_m;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(  // <<=== هذا هو المفتاح
                            child: TextFormField(
                              controller: _announcementImageController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: a_photo_Announcement_l,
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
                        child: ElevatedButton(style: style_button,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await announcementApi.addAnnouncement(
                                    store_id: 1, // أو خذ store_id من المستخدم الحالي
                                    announcement_description: _announcementNoteController.text,
                                    announcement_date: DateTime.now().toIso8601String(),
                                    announcement_state: true,
                                    announcement_photo: _announcementImageController.text,
                                  );


                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('تم إضافة الإعلان بنجاح!')),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Announcement()),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('فشل في إضافة الإعلان: $e')),
                                  );
                                }
                              }
                            },
                            child: Text(a_add_b)),
                      ),
                      SizedBox(height: 16)
                    ]
                ),
              ),
            ),
          ),
        )
    );
  }
}