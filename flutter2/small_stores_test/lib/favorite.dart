import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/showproduct.dart';

import 'apiService/api_service.dart';
import 'apiService/favorit_api.dart';
import 'apiService/product_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/favoritemodel.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class Favorite extends StatefulWidget {
  final User user;

  Favorite({Key? key, required this.user}) : super(key: key);

  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _favoriteProducts = [];
  List<Map<String, dynamic>> _filteredFavorites = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));

      final user_id = widget.user.id;
      final favorites = await favoritApi.getFavorits(user_id);

      final List<Map<String, dynamic>> products = [];
      for (var fav in favorites) {
        final product = await productApi.getProduct(fav.product_id);
        products.add({
          'product': product,
          'favorite': fav,
        });
      }

      setState(() {
        _favoriteProducts = products;
        _filteredFavorites = List.from(products);
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في جلب المفضلات: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String query) {
    setState(() {
      _filteredFavorites = _favoriteProducts.where((item) {
        final product = item['product'] as ProductModel;
        return product.product_name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // دالة لتحديد عدد الأعمدة بناءً على حجم الشاشة
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 4; // شاشات كبيرة جداً
    } else if (width > 800) {
      return 3; // أجهزة لوحية
    } else if (width > 600) {
      return 2; // أجهزة لوحية صغيرة
    } else {
      return 2; // هواتف
    }
  }

  // دالة لتحديد نسبة العرض إلى الارتفاع للعناصر
  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 0.8; // شاشات كبيرة
    } else if (width > 800) {
      return 0.9; // أجهزة لوحية
    } else {
      return 0.75; // هواتف
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24.0 : 16.0),
              child: Column(
                children: [
                  // حقل البحث
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: a_product_name_s,
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: constraints.maxWidth > 600 ? 16.0 : 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: _applyFilter,
                    ),
                  ),

                  SizedBox(height: constraints.maxWidth > 600 ? 24.0 : 16.0),

                  // العنوان الرئيسي
                  Padding(
                    padding: EdgeInsets.all(constraints.maxWidth > 600 ? 16.0 : 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        a_favort_s,
                        style: style_text_titel.copyWith(
                          fontSize: constraints.maxWidth > 600 ? 24.0 : 20.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: constraints.maxWidth > 600 ? 24.0 : 16.0),

                  // شبكة المنتجات المفضلة
                  Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _filteredFavorites.isEmpty
                        ? Center(
                      child: Text(
                        'لا يوجد منتجات مفضلة',
                        style: TextStyle(
                          fontSize: constraints.maxWidth > 600 ? 18.0 : 16.0,
                        ),
                      ),
                    )
                        : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        crossAxisSpacing: constraints.maxWidth > 600 ? 24.0 : 16.0,
                        mainAxisSpacing: constraints.maxWidth > 600 ? 24.0 : 16.0,
                        childAspectRatio:1.2
                        //_getChildAspectRatio(context),
                      ),
                      itemCount: _filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final item = _filteredFavorites[index];
                        final product = item['product'] as ProductModel;
                        final favorite = item['favorite'] as Favorit;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowProduct(
                                  product_id: product.id,
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                // صورة المنتج
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(product.product_photo_1),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // تدرج
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
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
                                // اسم المنتج
                                Padding(
                                  padding: EdgeInsets.all(constraints.maxWidth > 600 ? 12.0 : 8.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      product.product_name,
                                      style: style_text_normal_w.copyWith(
                                        fontSize: constraints.maxWidth > 600 ? 16.0 : 14.0,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
            ),
          );
        },
      ),
    );
  }
}