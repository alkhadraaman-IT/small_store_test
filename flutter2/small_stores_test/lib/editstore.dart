import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/mystore.dart';
import 'package:small_stores_test/store.dart';
import 'package:image_picker/image_picker.dart';

import 'apiService/api_service.dart';
import 'apiService/store_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class EditStore extends StatefulWidget {
  final StoreModel store; // 🔥 استقبل بيانات المتجر
  final User user; // إضافة المتغير

  EditStore({Key? key,required this.store, required this.user}): super(key: key);

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
  void initState() {
    super.initState();

    // تحميل بيانات المتجر في الـ Controllers
    _storeNameController.text = widget.store.store_name;
    _storePlanController.text = widget.store.store_place;
    _storePhoneController.text = widget.store.store_phone;
    _storeNoteController.text = widget.store.store_description;
    _storeImageController.text = widget.store.store_photo;
    _selectedClassStore = _classStore[widget.store.class_id];
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
                          onChanged: null, //  تعطيل التغيير
                          validator: null, //  لا حاجة للتحقق لأنو ما رح يتغير
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
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      // استخراج class_id من النص المختار
                                      final int classId = _classStore.indexOf(_selectedClassStore!);

                                      final updatedStore = StoreModel(
                                        id: widget.store.id,
                                        user_id: widget.store.user_id,
                                        store_name: _storeNameController.text,
                                        store_phone: _storePhoneController.text,
                                        store_place: _storePlanController.text,
                                        class_id: classId,
                                        store_description: _storeNoteController.text,
                                        store_state: 1,
                                        store_photo: _storeImageController.text,
                                      );

                                      final api = StoreApi(apiService: ApiService(client: http.Client())); // ⚠️ تأكد إنك مرّرته صح
                                      await api.updateStore(widget.store.id, updatedStore);

                                      // الرجوع أو رسالة نجاح
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تم تعديل المتجر بنجاح')),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => Store(store_id: widget.store.id,user: widget.user,)),
                                      );
                                    } catch (e) {
                                      print(" خطأ أثناء التعديل: $e");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('حدث خطأ أثناء التعديل')),
                                      );
                                    }
                                  }
                                },
                                child: Text(a_edit_b))),
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