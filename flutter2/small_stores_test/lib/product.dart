import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:small_stores_test/editproduct.dart';
import 'apiService/api_service.dart';
import 'apiService/favorit_api.dart';
import 'apiService/product_api.dart';
import 'apiService/store_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'store.dart';
import 'style.dart';
import 'variables.dart';

class Product extends StatefulWidget {
  final int product_id;
  final int class_id;
  final User user;

  const Product({
    Key? key,
    required this.product_id,
    required this.user,
    required this.class_id,
  }) : super(key: key);

  @override
  _Product createState() => _Product();
}

class _Product extends State<Product> {
  ProductModel? _product;
  bool showOptions = false; // افتراضياً الأزرار تظهر

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Center(
          child: ProductBody(
            product_id: widget.product_id,
            onProductLoaded: (product) {
              setState(() {
                _product = product;
              });
            },
            canEditAvailability: true,
          ),
        ),
      ),

      // ✅ الأزرار العائمة
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_product != null && showOptions) ...[
            // زر التعديل
            FloatingActionButton(
              heroTag: "editBtn",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProduct(
                      product: _product!,
                      user: widget.user,
                      class_id: widget.class_id,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.edit, color: color_main),
            ),
            SizedBox(height: 10),

            // زر الحذف
            FloatingActionButton(
              heroTag: "deleteBtn",
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('تأكيد الحذف'),
                    content: Text('هل أنت متأكد من حذف هذا المنتج؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('حذف',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm) {
                  try {
                    final productApi = ProductApi(
                        apiService: ApiService(client: http.Client()));
                    await productApi.deleteProduct(_product!.id);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل حذف المنتج: $e')),
                    );
                  }
                }
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.delete, color: Colors.red),
            ),
            SizedBox(height: 10),
          ],

          // زر القائمة (إظهار/إخفاء)
          FloatingActionButton(
            heroTag: "moreBtn",
            onPressed: () {
              setState(() {
                showOptions = !showOptions;
              });
            },
            backgroundColor: color_main,
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProductBody extends StatefulWidget {
  final int product_id;
  final Function(ProductModel)? onProductLoaded;
  final bool canEditAvailability;

  ProductBody({
    required this.product_id,
    this.onProductLoaded,
    this.canEditAvailability = false,
  });

  @override
  _ProductBody createState() => _ProductBody();
}

class _ProductBody extends State<ProductBody> {
  final TextEditingController _productStaiteController = TextEditingController();

  late ProductModel _product;
  late String _typeName = '';
  late String _storeName = '';
  bool _isLoading = true;
  int _productAvailable = 0;
  int _likesCount = 0;

  final ProductApi _productApi =
  ProductApi(apiService: ApiService(client: http.Client()));

  @override
  void initState() {
    super.initState();
    fetchProduct();
    _loadLikesCount(); // تحميل عدد المعجبين عند التهيئة
  }

  /// جلب بيانات المنتج
  Future<void> fetchProduct() async {
    try {
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));

      final fetchedProduct = await productApi.getProduct(widget.product_id);

      if (widget.onProductLoaded != null) {
        widget.onProductLoaded!(fetchedProduct);
      }

      final fetchedType = await typeApi.getType(fetchedProduct.type_id);
      final fetchedStore = await storeApi.getStore(fetchedProduct.store_id);

      setState(() {
        _product = fetchedProduct;
        _typeName = fetchedType.type_name;
        _storeName = fetchedStore.store_name;
        _productAvailable = _product.product_available;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ أثناء جلب المنتج أو المتجر أو النوع: $e');
    }
  }

  /// جلب عدد الإعجابات من الـ API
  Future<void> _loadLikesCount() async {
    try {
      final favoritApi =
      FavoritApi(apiService: ApiService(client: http.Client()));
      final count = await favoritApi.getProductLikesCount(widget.product_id);
      setState(() {
        _likesCount = count;
      });
    } catch (e) {
      print('Error loading likes count: $e');
    }
  }

  /// تحديث حالة التوفر
  Future<void> _updateAvailability(bool newValue) async {
    try {
      setState(() {
        _product.product_available = newValue ? 1 : 0;
      });

      final updatedProduct = ProductModel(
        id: _product.id,
        store_id: _product.store_id,
        product_name: _product.product_name,
        type_id: _product.type_id,
        product_description: _product.product_description,
        product_price: _product.product_price,
        product_available: newValue ? 1 : 0,
        product_state: _product.product_state,
        product_photo_1: _product.product_photo_1,
        product_photo_2: _product.product_photo_2,
        product_photo_3: _product.product_photo_3,
        product_photo_4: _product.product_photo_4,
      );

      await _productApi.updateProduct(_product.id, updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(newValue ? 'تم تفعيل توفر المنتج' : 'تم إلغاء توفر المنتج'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _product.product_available = newValue ? 0 : 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء التحديث'),
          duration: Duration(seconds: 2),
        ),
      );
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
          Image.network(
            _product.product_photo_1,
            height: 160,
          ),
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
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 8),
              Text('عدد المحبين: $_likesCount', style: style_text_normal),
            ],
          ),
          SizedBox(height: 8),
          Text('$a_product_type_s: $_typeName', style: style_text_normal),
          SizedBox(height: 8),
          Text('$a_product_note_s: ${_product.product_description}',
              style: style_text_normal),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                _product.product_available == 1
                    ? Icons.check_circle
                    : Icons.cancel,
                color: _product.product_available == 1
                    ? Colors.green
                    : Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                'حالة التوفر: ${_product.product_available == 1 ? "متوفر" : "غير متوفر"}',
                style: style_text_normal,
              ),
              if (widget.canEditAvailability) ...[
                SizedBox(width: 16),
                /*Switch(
                  value: _product.product_available == 1,
                  onChanged: _updateAvailability,
                  activeColor: color_main,
                ),*/
              ],
            ],
          ),
        ],
      ),
    );
  }
}
