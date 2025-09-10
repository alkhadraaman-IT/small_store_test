import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:small_stores_test/appbar.dart' show CustomAppBar;
import 'package:small_stores_test/drawer.dart';

import 'apiService/announcement_api.dart';
import 'apiService/api_service.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class AddAnnouncement extends StatefulWidget {
  final User user;
  final int store_id;

  const AddAnnouncement({super.key, required this.user, required this.store_id});

  @override
  _AddAnnouncement createState() => _AddAnnouncement();
}

class _AddAnnouncement extends State<AddAnnouncement> {
  final TextEditingController _announcementNoteController = TextEditingController();
  final TextEditingController _announcementImageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage; // للموبايل/ديسكتوب
  Uint8List? _webImage; // للويب
  bool _isLoading = false;
  late final AnnouncementApi announcementApi;

  @override
  void initState() {
    super.initState();
    announcementApi = AnnouncementApi(apiService: ApiService(client: http.Client()));
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          // في الويب نقرأ الصورة كـ bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            _announcementImageController.text = pickedFile.name;
          });
        } else {
          // في الموبايل/ديسكتوب نستخدم File
          setState(() {
            _selectedImage = File(pickedFile.path);
            _announcementImageController.text = pickedFile.path;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في اختيار الصورة: $e')),
      );
    }
  }

  Future<void> _submitAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يجب اختيار صورة للإعلان')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Uint8List imageBytes;
      if (kIsWeb && _webImage != null) {
        imageBytes = _webImage!;
      } else if (_selectedImage != null) {
        imageBytes = Uint8List.fromList(await _selectedImage!.readAsBytes());
      } else {
        throw Exception('يجب اختيار صورة للإعلان');
      }

      await announcementApi.addAnnouncement(
        store_id: widget.store_id,
        announcement_description: _announcementNoteController.text,
        announcement_date: DateTime.now().toIso8601String(),
        announcement_state: 1,
        announcementPhotoBytes: imageBytes,
      );

      _announcementNoteController.clear();
      _announcementImageController.clear();
      setState(() {
        _selectedImage = null;
        _webImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة الإعلان بنجاح!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة الإعلان: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _announcementNoteController.dispose();
    _announcementImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  image_logo_b,
                  SizedBox(height: 16),
                  Text(a_AddAnnouncement_s, style: style_text_titel),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _announcementNoteController,
                    decoration: InputDecoration(
                      labelText: a_text_Announcement_l,
                      prefixIcon: Icon(Icons.sticky_note_2_rounded),
                    ),
                    keyboardType: TextInputType.name,
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_store_name_m;
                      }
                      if (value.length > 100) {
                        return 'لا يجوز أن يكون الإعلان أكثر من 100 محرف';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _announcementImageController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: a_photo_Announcement_l,
                            prefixIcon: Icon(Icons.image),
                          ),
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
                        style: styleButton(color_main),
                        onPressed: _pickImage,
                        child: Text(a_add_b),
                      ),
                    ],
                  ),
                  if (kIsWeb && _webImage != null) ...[
                    SizedBox(height: 16),
                    Image.memory(
                      _webImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ] else if (_selectedImage != null) ...[
                    SizedBox(height: 16),
                    Image.file(
                      _selectedImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: styleButton(color_main),
                      onPressed: _isLoading ? null : _submitAnnouncement,
                      child: Text(_isLoading ? 'جاري الإضافة...' : a_add_b),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
