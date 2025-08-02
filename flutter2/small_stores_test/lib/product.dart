import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:small_stores_test/editproduct.dart';
import 'apiService/api_service.dart';
import 'apiService/product_api.dart';
import 'apiService/store_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/productmodel.dart';
import 'store.dart';

import 'style.dart';
import 'variables.dart';

class Product extends StatefulWidget {
  @override
  _Product createState() => _Product();
}

class _Product extends State<Product> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: ProductBody(productId: 1), // أو ID المنتج اللي بدك تعرضه
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProduct()),
          );
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}


class ProductBody extends StatefulWidget {
  final int productId;

  ProductBody({required this.productId});

  @override
  _ProductBody createState() => _ProductBody();
}

class _ProductBody extends State<ProductBody> {
  final TextEditingController _productStaiteController = TextEditingController();

  late ProductModel _product;
  late String _typeName = '';
  late String _storeName = ''; // جديد
  bool _isLoading = true;
  int _productAvailable = 0;
  int _likesCount = 0; // عدد المعجبين المحسوب

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));

      final fetchedProduct = await productApi.getProduct(widget.productId);
      final fetchedType = await typeApi.getType(fetchedProduct.type_id);
      final fetchedStore = await storeApi.getStore(fetchedProduct.store_id);

      setState(() {
        _product = fetchedProduct;
        _typeName = fetchedType.type_name;
        _storeName = fetchedStore.store_name;  // اسم المتجر
        _productAvailable = _product.product_available;
        _isLoading = false;
      });
    } catch (e) {
      print(' خطأ أثناء جلب المنتج أو المتجر أو النوع: $e');
    }
  }

  @override
  void dispose() {
    _productStaiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(_product.product_photo_1),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_product.product_name, style: style_text_normal),
              Text('${_product.product_price} \$', style: style_text_normal),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.store),
              SizedBox(width: 8),
              Text(_storeName, style: style_text_normal),
            ],
          ),
          SizedBox(height: 16),
          Text('عدد المحبين: ${_likesCount}', style: style_text_normal),
          SizedBox(height: 8),
          Text('$a_product_type_s: $_typeName', style: style_text_normal),
          SizedBox(height: 8),
          Text('$a_product_note_s: ${_product.product_description}', style: style_text_normal),
          SizedBox(height: 16),
      Text(
        'الحالة: ${_product.product_available == 1 ? "متوفر" : "غير متوفر"}',
        style: style_text_normal,
      ),

      CheckboxListTile(
        title: Text(a_product_stati_s),
        value: _product.product_available == 1, // تحويل int إلى bool للـ Checkbox
        onChanged: (newValue) {
          setState(() {
            _product.product_available = newValue! ? 1 : 0; // تحويل bool إلى int
          });
        },
          ),
        ],
      ),
    );
  }
}
