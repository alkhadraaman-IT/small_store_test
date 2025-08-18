import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/models/storemodel.dart';
import 'package:small_stores_test/product.dart';

import 'addproduct.dart';
import 'apiService/api_service.dart';
import 'apiService/product_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'showproduct.dart';
import 'style.dart';
import 'variables.dart';

class ProductAll extends StatefulWidget {
  final StoreModel store;
  final User user;

  const ProductAll({Key? key, required this.store,required this.user}) : super(key: key);

  @override
  _ProductAll createState() => _ProductAll();
}

class _ProductAll extends State<ProductAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: ProductAllBody(store: widget.store,user:widget.user ,), // ✅ لا حاجة لـ SingleChildScrollView
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct(user: widget.user,store: widget.store,)),
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
  final bool page_view; // المتغير الجديد للتحكم في العرض

  const ProductAllBody({Key? key, required this.store,required this.user,this.page_view = true}) : super(key: key);

  @override
  _ProductAllBody createState() => _ProductAllBody();
}

class _ProductAllBody extends State<ProductAllBody> {
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
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

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameMatch = product.product_name.toLowerCase().contains(query);
        // بإمكانك تضيف هنا أي شرط ثاني للبحث
        return nameMatch;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _filteredProducts.map((product) {
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.product_name,
                                  style: style_text_normal_w,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${product.product_price.toStringAsFixed(2)} \$',
                                style: style_text_normal_w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
