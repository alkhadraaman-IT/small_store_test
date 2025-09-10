import 'dart:io' show File; // فقط للموبايل
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'apiService/api_service.dart';
import 'apiService/class_api.dart';
import 'apiService/store_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/classmodel.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class AddStore extends StatefulWidget {
  final User user;

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

  final _formKey = GlobalKey<FormState>();

  List<ClassModel> _storeClasses = [];
  int? _selectedClassId;

  File? _selectedImage;       // موبايل
  Uint8List? _webImage;       // ويب

  bool _isLoading = false;
  late StoreApi storeApi;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadStoreClasses();
    storeApi = StoreApi(apiService: ApiService(client: http.Client()));
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storePlanController.dispose();
    _storePhoneController.dispose();
    _storeClassController.dispose();
    _storeNoteController.dispose();
    _storeImageController.dispose();
    super.dispose();
  }

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

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _storeImageController.text = pickedFile.name;
        });
      }
    } else {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _storeImageController.text = pickedFile.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  image_logo_b,
                  const SizedBox(height: 16),
                  Text(a_add_store_s, style: style_text_titel),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _storeNameController,
                    decoration: InputDecoration(
                      labelText: a_store_name_s,
                      prefixIcon: Icon(Icons.storefront_rounded),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_store_name_m : null,
                  ),
                  const SizedBox(height: 16),
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
                    onChanged: (int? value) {
                      setState(() {
                        _selectedClassId = value;
                        _storeClassController.text = value.toString();
                      });
                    },
                    validator: (value) =>
                    value == null ? a_store_class_m : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _storeNoteController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: a_store_note_s,
                      prefixIcon: Icon(Icons.sticky_note_2_rounded),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_email_m : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _storePhoneController,
                    decoration: InputDecoration(
                      labelText: a_phone_l,
                      prefixIcon: const Icon(Icons.phone),
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                    value == null || value.isEmpty ? a_phone_m : null,
                    onChanged: (value) {
                      if (value.startsWith('0')) {
                        _storePhoneController.text = value.substring(1);
                        _storePhoneController.selection =
                            TextSelection.fromPosition(
                              TextPosition(offset: _storePhoneController.text.length),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _storePlanController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: a_store_plane_s,
                      prefixIcon: Icon(Icons.place),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_plan_store_m : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _storeImageController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: a_store_logo_s,
                            prefixIcon: Icon(Icons.image),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? a_store_logo_m : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: styleButton(color_main),
                        onPressed: _pickImage,
                        child: Text(a_add_b),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_webImage != null || _selectedImage != null)
                    SizedBox(
                      height: 120,
                      child: kIsWeb
                          ? Image.memory(_webImage!)
                          : Image.file(_selectedImage!),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: styleButton(color_main),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedClassId != null) {
                          setState(() => _isLoading = true);
                          try {
                            await storeApi.addStore(
                              user_id: widget.user.id,
                              store_name: _storeNameController.text,
                              store_phone: '+963${_storePhoneController.text}',
                              store_place: _storePlanController.text,
                              class_id: _selectedClassId!,
                              store_description: _storeNoteController.text,
                              store_photo: kIsWeb ? null : _selectedImage,
                              storePhotoBytes: kIsWeb ? _webImage : null, // ✅ Uint8List مقبولة لأنها List<int>
                            );

                            _storeNameController.clear();
                            _storePlanController.clear();
                            _storePhoneController.clear();
                            _storeClassController.clear();
                            _storeNoteController.clear();
                            _storeImageController.clear();
                            _selectedClassId = null;
                            _selectedImage = null;
                            _webImage = null;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم إضافة المتجر بنجاح')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('خطأ في الإضافة: $e')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(a_add_b),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
