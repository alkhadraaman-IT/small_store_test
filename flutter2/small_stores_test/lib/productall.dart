import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/models/storemodel.dart';
import 'package:small_stores_test/product.dart';

import 'addproduct.dart';
import 'apiService/api_service.dart';
import 'apiService/product_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/productmodel.dart';
import 'models/typemodel.dart';
import 'models/usermodel.dart';
import 'showproduct.dart';
import 'style.dart';
import 'variables.dart';

class ProductAll extends StatefulWidget {
  final StoreModel store;
  final User user;

  const ProductAll({Key? key, required this.store, required this.user}) : super(key: key);

  @override
  _ProductAll createState() => _ProductAll();
}

class _ProductAll extends State<ProductAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductAllBody(store: widget.store, user: widget.user),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct(user: widget.user, store: widget.store)),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}

class ProductAllBody extends StatefulWidget {
  final StoreModel store;
  final User user;
  final bool page_view;

  const ProductAllBody({Key? key, required this.store, required this.user, this.page_view = true}) : super(key: key);

  @override
  _ProductAllBody createState() => _ProductAllBody();
}

class _ProductAllBody extends State<ProductAllBody> {
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<ProductType> _types = [];
  int? _selectedTypeId;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadTypes();
    _searchController.addListener(_filterProducts);
  }

  void _loadProducts() async {
    try {
      final products = await ProductApi(
        apiService: ApiService(client: http.Client()),
      ).getProducts(widget.store.id);

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في جلب البيانات';
        _isLoading = false;
      });
    }
  }

  void _loadTypes() async {
    try {
      final types = await TypeApi(
        apiService: ApiService(client: http.Client()),
      ).getTypeClasses(widget.store.class_id);

      setState(() {
        _types = types;
      });
    } catch (e) {
      print('خطأ في جلب الأنواع: $e');
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameMatch = product.product_name.toLowerCase().contains(query);
        final typeMatch = _selectedTypeId == null || product.type_id == _selectedTypeId;
        return nameMatch && typeMatch;
      }).toList();
    });
  }

  void _filterByType(int? typeId) {
    setState(() {
      _selectedTypeId = typeId;
      _filterProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد عدد الأعمدة بناءً على عرض الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 4 : (screenWidth > 800 ? 3 : 2);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // حقل البحث
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "بحث عن منتج",
              suffixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
          ),
          SizedBox(height: 16),

          // شريط الفلترة حسب النوع
          if (_types.isNotEmpty) ...[
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // خيار "كل المنتجات"
                  SizedBox(
                    width: 120, // عرض ثابت لكل المستطيلات
                    child: GestureDetector(
                      onTap: () => _filterByType(null),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _selectedTypeId == null ? Colors.white : color_main,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: color_main,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'كل المنتجات',
                            style: TextStyle(
                              color: _selectedTypeId == null ? color_main : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // أنواع المنتجات
                  ..._types.map((type) {
                    return SizedBox(
                      width: 120, // عرض ثابت لكل المستطيلات
                      child: GestureDetector(
                        onTap: () => _filterByType(type.id),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _selectedTypeId == type.id ? Colors.white : color_main,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color_main,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              type.type_name,
                              style: TextStyle(
                                color: _selectedTypeId == type.id ? color_main : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],

          Align(
            alignment: Alignment.centerRight,
            child: Text('المنتجات', style: style_text_titel),
          ),
          SizedBox(height: 16),

          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _filteredProducts.isEmpty
                ? Center(child: Text('لا توجد منتجات'))
                : GridView.builder(
              // استخدام GridView.builder لأداء أفضل
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // استخدام القيمة الديناميكية
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2, // تعديل النسبة لتناسب المحتوى
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.page_view
                            ? Product(
                          product_id: product.id,
                          class_id: widget.store.class_id,
                          user: widget.user,
                        )
                            : ShowProduct(
                          product_id: product.id,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // صورة المنتج
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(product.product_photo_1),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // التدرج
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        // الاسم والسعر
                        Positioned(
                          bottom: 8,
                          right: 8,
                          left: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.product_name,
                                style: style_text_normal_w.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${product.product_price.toStringAsFixed(2)} \$',
                                style: style_text_normal_w.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}