import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data'; // إضافة هذا الاستيراد
import 'package:small_stores_test/models/storemodel.dart';
import 'package:small_stores_test/product.dart';
import 'package:image_picker/image_picker.dart';
import 'apiService/api_service.dart';
import 'apiService/product_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/typemodel.dart';
import 'models/usermodel.dart';
import 'store.dart';
import 'style.dart';
import 'variables.dart';

class AddProduct extends StatefulWidget {
  final User user; // إضافة المتغير
  final StoreModel store; // إضافة المتغير

  const AddProduct({super.key, required this.user, required this.store});

  @override
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStaiteController = TextEditingController();
  final TextEditingController _productNoteController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  List<ProductType> _types = [];
  ProductType? _selectedType;
  Uint8List? _productImageBytes; // إضافة متغير لتخزين bytes الصورة

  @override
  void initState() {
    super.initState();
    fetchTypes();
  }

  Future<void> fetchTypes() async {
    final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
    final fetchedTypes = await typeApi.getTypeClasses(widget.store.class_id);
    setState(() {
      _types = fetchedTypes;
    });
  }

  bool _productAvailable = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // تقليل الجودة
      maxWidth: 800,    // تحديد العرض الأقصى
      maxHeight: 800,   // تحديد الطول الأقصى
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      if (bytes.length > 4 * 1024 * 1024) { // 4MB كحد أقصى
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("حجم الصورة كبير جداً"))
        );
        return;
      }
      setState(() {
        _productImageBytes = bytes;
        _productImageController.text = pickedFile.name;
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productTypeController.dispose();
    _productPriceController.dispose();
    _productStaiteController.dispose();
    _productNoteController.dispose();
    _productImageController.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  image_logo_b,
                  SizedBox(height: 16),
                  Text(a_add_product_s, style: style_text_titel),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      labelText: a_product_name_s,
                      prefixIcon: Icon(Icons.sell),
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25), // تحديد عدد المحارف
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_first_name_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<ProductType>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'نوع المنتج',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _types.map((type) {
                      return DropdownMenuItem<ProductType>(
                        value: type,
                        child: Text(type.type_name),
                      );
                    }).toList(),
                    onChanged: (newType) {
                      setState(() {
                        _selectedType = newType;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'يرجى اختيار نوع المنتج';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _productNoteController,
                    decoration: InputDecoration(
                      labelText: a_product_note_s,
                      prefixIcon: Icon(Icons.sticky_note_2_rounded),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 255,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_email_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _productPriceController,
                    decoration: InputDecoration(
                      labelText: a_product_monye_s,
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25), // تحديد عدد المحارف
                      FilteringTextInputFormatter.deny(RegExp(r'[a-z]')), // يمنع الأرقام
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_phone_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(
                      a_product_stati_s,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _productAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _productAvailable = value;
                      });
                    },
                    activeColor: color_main, // لون عندما يكون في حالة "on"
                    inactiveTrackColor: Colors.grey[300], // لون المسار عندما يكون في حالة "off"
                    contentPadding: EdgeInsets.only(left: 8), // تعديل المسافة
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _productImageController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: a_product_logo_s,
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
                        style: styleButton(color_main),
                        onPressed: _pickImage,
                        child: Text(a_add_b),
                      ),
                    ],
                  ),
                  // بعد حقل اختيار الصورة
                  if (_productImageBytes != null)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.memory(_productImageBytes!, fit: BoxFit.cover),
                    )
                  else
                    Text(
                      "لم يتم اختيار صورة",
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: styleButton(color_main),
                      onPressed: () async {
                        print('الصورة المختارة: $_productImageBytes');
                        print('اسم الصورة: ${_productImageController.text}');

                        if (_formKey.currentState!.validate()) {
                          if (_productImageBytes == null) {
                            print('لم يتم اختيار صورة!');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("يرجى اختيار صورة للمنتج"))
                            );
                            return;
                          }

                          try {
                            final productApi = ProductApi(
                                apiService: ApiService(client: http.Client()));

                            await productApi.addProduct(
                              store_id: widget.store.id,
                              product_name: _productNameController.text,
                              type_id: _selectedType!.id,
                              product_description: _productNoteController.text,
                              product_price: _productPriceController.text,
                              product_available: _productAvailable ? 1 : 0,
                              product_photo_1: _productImageBytes!, // إرسال bytes
                            );

                            // مسح الحقول
                            _productNameController.clear();
                            _productPriceController.clear();
                            _productNoteController.clear();
                            _productImageController.clear();
                            setState(() {
                              _selectedType = null;
                              _productImageBytes = null;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("تم إضافة المنتج بنجاح")));

                          } catch (e) {
                            print('Error details: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("فشل الإضافة: $e")));
                          }
                        }
                      },
                      child: Text(a_add_b),
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