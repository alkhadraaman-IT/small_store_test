import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:small_stores_test/product.dart';
import 'package:image_picker/image_picker.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProduct createState() => _EditProduct();
}

class _EditProduct extends State<EditProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStaiteController = TextEditingController();
  final TextEditingController _productNoteController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form

  final List<String> _productTypes = [' مالح', 'حلو', 'عصير',];
  String? _selectedProductType;
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
    // 5. تنظيف الـ Controller عند إغلاق الشاشة (مهم!)
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
    child: Form( // ✅ إحاطة النموذج بـ Form
    key: _formKey,
    child: Column(
    children: [
                image_login,
                SizedBox(height: 16),
                Text(a_add_product_s,style: style_text_titel),
                SizedBox(height: 16),
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    labelText: a_product_name_s,
                    prefixIcon: Icon(Icons.sell),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return a_first_name_m;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: _selectedProductType,
        decoration: InputDecoration(
          labelText: a_product_type_s,
          prefixIcon: Icon(Icons.type_specimen),
        ),
        items: _productTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedProductType = value;
            _productTypeController.text = value ?? '';

          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return a_product_class_m;
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
      CheckboxListTile(
        title: Text(a_product_stati_s),
        value: _productAvailable,
        onChanged: (newValue) {
          setState(() {
            _productAvailable = newValue ?? false;
          //  _productStaiteController.text = _productAvailable ? 'متوفر' : 'غير متوفر';
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),

      SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(  // <<=== هذا هو المفتاح
                      child: TextFormField(
                        controller: _productImageController,
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
                      MaterialPageRoute(builder: (context) => Product()),
                    );
                  }
                }, child: Text(a_edit_b))),
                SizedBox(height: 16),
    ],
    ),
    )
    )
        )
        )
    );
  }
}
