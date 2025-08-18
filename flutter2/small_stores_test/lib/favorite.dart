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
        _filteredFavorites = List.from(products); // أول مرة نفس القائمة
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
        return product.product_name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // حقل البحث
              TextFormField(
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
                ),
                keyboardType: TextInputType.name,
                onChanged: _applyFilter,
              ),

              SizedBox(height: 16),

              // العنوان الرئيسي
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    a_favort_s,
                    style: style_text_titel,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // شبكة المنتجات المفضلة
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _filteredFavorites.isEmpty
                    ? Center(child: Text('لا يوجد منتجات مفضلة'))
                    : GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: _filteredFavorites.map((item) {
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
                              favorite_id: favorite.id,
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
                            // تدرج
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
                            // اسم
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(product.product_name,
                                        style: style_text_normal_w),
                                  ],
                                ),
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
        ),
      ),
    );
  }
}
