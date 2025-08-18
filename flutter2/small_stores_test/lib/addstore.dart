import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/models/classmodel.dart';
import 'package:small_stores_test/mystore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:small_stores_test/store.dart';

import 'apiService/api_service.dart';
import 'apiService/class_api.dart';
import 'apiService/store_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class AddStore extends StatefulWidget {
  final User user; // إضافة المتغير

  const AddStore({super.key, required this.user});

  @override
  _AddStore createState() => _AddStore();
}

class _AddStore extends State<AddStore> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storePlanController = TextEditingController();
  final TextEditingController _storePhoneController = TextEditingController();
  final TextEditingController _storeClassController = TextEditingController();
  final TextEditingController _storeNoteController = TextEditingController();
  final TextEditingController _storeImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  /*
  final List<String> _classStore = ['إلكترونيات', 'ملابس', 'أغذية', 'أثاث', 'ألعاب'];
  String? _selectedClassStore;
  */
  List<ClassModel> _storeClasses = [];
  int? _selectedClassId;
  Future<void> _loadStoreClasses() async {
    try {
      final classes = await ClassApi(apiService: ApiService(client: http.Client())).getClasses();
      setState(() {
        _storeClasses = classes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل الفئات: ${e.toString()}')),
      );
    }
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _storeImageController.text = pickedFile.path;
      });
    }
  }

  File? _selectedImage;
  bool _isLoading = false;
  late StoreApi storeApi;

  @override
  void initState() {
    super.initState();
    _loadStoreClasses();
    storeApi = StoreApi(apiService: ApiService(client: http.Client()));
  }

  @override
  void dispose() {
    // 5. تنظيف الـ Controller عند إغلاق الشاشة (مهم!)
    _storeNameController.dispose();
    _storePlanController.dispose();
    _storePhoneController.dispose();
    _storeClassController.dispose();
    _storeNoteController.dispose();
    _storeImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(user: widget.user,),
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
                        Text(a_add_store_s,style: style_text_titel),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _storeNameController,
                          decoration: InputDecoration(
                            labelText: a_store_name_s,
                            prefixIcon: Icon(Icons.storefront_rounded),
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
                        DropdownButtonFormField<int>(
                          value: _selectedClassId,
                          decoration: InputDecoration(
                            labelText: a_class_store_s,
                            prefixIcon: Icon(Icons.type_specimen),
                          ),
                          items: _storeClasses.map((storeClass) {
                            return DropdownMenuItem<int>(
                              value: storeClass.id,
                              child: Text(storeClass.class_name),
                            );
                          }).toList(),
                          onChanged: (int? value) { // تحديد نوع المعلمة كـ int?
                            setState(() {
                              _selectedClassId = value; // ناقص هذه السطر
                              _storeClassController.text = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return a_store_class_m;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _storeNoteController,
                          decoration: InputDecoration(
                            labelText: a_store_note_s,
                            prefixIcon: Icon(Icons.sticky_note_2_rounded),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return a_email_m;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _storePhoneController,
                          decoration: InputDecoration(
                            labelText: a_phone_l,
                            prefixIcon: Icon(Icons.phone),
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '+963',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(9), // 9 خانات فقط بعد +963
                            FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')), // يمنع الحروف
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return a_phone_m;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _storePlanController,
                          decoration: InputDecoration(
                            labelText: a_store_plane_s,
                            prefixIcon: Icon(Icons.place),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return a_plan_store_m;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(  // <<=== هذا هو المفتاح
                              child: TextFormField(
                                controller: _storeImageController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: a_store_class_s,
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
                                if (_storePhoneController.text.isNotEmpty &&
                                    !_storePhoneController.text.startsWith('9') && _storePhoneController.text.length != 9) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('رقم الهاتف يجب يكون ثمان أرقام وأن يبدأ بـ 9')),
                                  );
                                  return;
                                }

                                if (_formKey.currentState!.validate() && _selectedClassId != null) {
                                  setState(() => _isLoading = true);
                                  print('User ID: ${widget.user.id}');

                                  try {
                                    final newStore = await storeApi.addStore( // ✅ الصحيح
                                      user_id: widget.user.id,
                                      store_name: _storeNameController.text,
                                      store_phone: '+963${_storePhoneController.text}',
                                      store_place: _storePlanController.text,
                                      class_id: _selectedClassId!, // استخدام ID الفئة المختارة
                                      store_description: _storeNoteController.text,
                                      store_photo: _storeImageController.text,
                                    );
                                    _storeNameController.clear();
                                    _storePlanController.clear();
                                    _storePhoneController.clear();
                                    _storeClassController.clear();
                                    _storeNoteController.clear();
                                    _storeImageController.clear();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('تم إضافة المتجر بنجاح')),
                                    );

                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('خطأ في الإضافة: ${e.toString()}')),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                              child: _isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(a_add_b),
                            ),
                        ),
                        SizedBox(height: 16),
                      ]
                  ),
                ),
              ),
            )
        )
    );
  }
}