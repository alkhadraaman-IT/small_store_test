import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:small_stores_test/mystore.dart';
import 'package:small_stores_test/store.dart';
import 'package:image_picker/image_picker.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class EditStore extends StatefulWidget {
  @override
  _EditStore createState() => _EditStore();
}

class _EditStore extends State<EditStore> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storePlanController = TextEditingController();
  final TextEditingController _storePhoneController = TextEditingController();
  final TextEditingController _storeClassController = TextEditingController();
  final TextEditingController _storeNoteController = TextEditingController();
  final TextEditingController _storeImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form
  final List<String> _classStore = ['إلكترونيات', 'ملابس', 'أغذية', 'أثاث', 'ألعاب'];
  String? _selectedClassStore;

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _storeImageController.text = pickedFile.path;
      }
      );
    }
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
                Text(a_edit_store_s,style: style_text_titel),
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
      DropdownButtonFormField<String>(
        value: _selectedClassStore,
        decoration: InputDecoration(
          labelText: a_class_store_s,
          prefixIcon: Icon(Icons.type_specimen),
        ),
        items: _classStore.map((storeClass) {
          return DropdownMenuItem<String>(
            value: storeClass,
            child: Text(storeClass),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedClassStore = value;
            _storeClassController.text = value ?? '';

          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
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
          child: ElevatedButton(style: style_button,onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Store()),
                    );
                  }
                }, child: Text(a_edit_b))),
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