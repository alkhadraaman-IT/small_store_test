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
import 'models/productmodel.dart';
import 'models/typemodel.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class EditProduct extends StatefulWidget {
  final User user; // إضافة المتغير
  final ProductModel product; // إضافة بارامتر للمنتج
  final int class_id;

  const EditProduct({Key? key, required this.product, required this.user,required this.class_id}) : super(key: key);


  @override
  _EditProduct createState() => _EditProduct();
}

class _EditProduct extends State<EditProduct> {

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productNoteController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<ProductType> _productTypes = [];
  ProductType? _selectedType;
  bool _productAvailable = false;
  bool _isLoading = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
    final types = await typeApi.getTypeClasses(widget.class_id);

    setState(() {
      _productTypes = types;
      _selectedType = types.firstWhere((type) => type.id == widget.product.type_id);
      _productNameController.text = widget.product.product_name;
      _productPriceController.text = widget.product.product_price.toString();
      _productNoteController.text = widget.product.product_description;
      _productAvailable = widget.product.product_available == 1;
      _productImageController.text = widget.product.product_photo_1;
      _isLoading = false;  // هنا!!
    });
  }

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
    _productPriceController.dispose();
    _productNoteController.dispose();
    _productImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              image_logo_b,
              SizedBox(height: 16),
              Text(a_edit_product_s, style: style_text_titel),
              SizedBox(height: 16),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: a_product_name_s,
                  prefixIcon: Icon(Icons.sell),
                ),
                validator: (value) => value == null || value.isEmpty ? a_first_name_m : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<ProductType>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'نوع المنتج',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _productTypes.map((type) {
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
                validator: (value) => value == null || value.isEmpty ? a_email_m : null,
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
                  LengthLimitingTextInputFormatter(25),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) => value == null || value.isEmpty ? a_phone_m : null,
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text(a_product_stati_s),
                value: _productAvailable,
                onChanged: (val) {
                  setState(() {
                    _productAvailable = val ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _productImageController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: a_store_class_s,
                        prefixIcon: Icon(Icons.image),
                      ),
                      validator: (value) => value == null || value.isEmpty ? a_store_logo_m : null,
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
                child: ElevatedButton(
                  style: style_button,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final updatedProduct = ProductModel(
                          id: widget.product.id,
                          store_id: widget.product.store_id,
                          product_name: _productNameController.text,
                          type_id: _selectedType!.id,
                          product_description: _productNoteController.text,
                          product_price: double.parse(_productPriceController.text),
                          product_available: _productAvailable ? 1 : 0,
                          product_state: widget.product.product_state,
                          product_photo_1: _productImageController.text,
                          product_photo_2: widget.product.product_photo_2,
                          product_photo_3: widget.product.product_photo_3,
                          product_photo_4: widget.product.product_photo_4,
                        );
                        print(updatedProduct.toJson());

                        await ProductApi(apiService: ApiService(client: http.Client()))
                            .updateProduct(updatedProduct.id, updatedProduct);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم تحديث المنتج بنجاح')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ أثناء التحديث: $e')),
                        );
                      }
                    }
                  },

                  child: Text(a_edit_b),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
