import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/product.dart';
import 'package:image_picker/image_picker.dart';
import 'apiService/api_service.dart';
import 'apiService/product_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/typemodel.dart';
import 'store.dart';
import 'style.dart';
import 'variables.dart';

class AddProduct extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    fetchTypes();
  }

  Future<void> fetchTypes() async {
    final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
    final fetchedTypes = await typeApi.getTypes();
    setState(() {
      _types = fetchedTypes;
    });
  }

  bool _productAvailable = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImageController.text = pickedFile.path;
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
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  image_login,
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
                    items: _types.map((type) {
                      return DropdownMenuItem<ProductType>(
                        value: type,
                        child: Text(type.type_name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'اختر نوع المنتج';
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_email_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
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
                        style: style_button,
                        onPressed: _pickImage,
                        child: Text(a_add_b),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text(a_product_stati_s),
                    value: _productAvailable,
                    onChanged: (newValue) {
                      setState(() {
                        _productAvailable = newValue ?? false;
                        _productStaiteController.text =
                        _productAvailable ? 'متوفر' : 'غير متوفر'; // تحديث النص هنا
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: style_button,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // إنشاء كائن API
                            final productApi = ProductApi(
                                apiService: ApiService(client: http.Client()));
                            // أرسل البيانات
                            await productApi.addProduct(
                              store_id: 1, // عدّل حسب التطبيق
                              product_name: _productNameController.text,
                              type_id: _selectedType!.id,
                              product_description: _productNoteController.text,
                              product_price: _productPriceController.text,
                              product_available:
                              _productAvailable ? 1 : 0, // تحويل القيمة هنا
                              product_photo_1: _productImageController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("تم إضافة المنتج بنجاح")));
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Store()),
                            );
                          } catch (e) {
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