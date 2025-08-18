import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../apiService/api_service.dart';
import '../apiService/favorit_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/favoritemodel.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'style.dart';
import 'variables.dart';

class ShowProduct extends StatefulWidget {
  final int product_id;
  final int? favorite_id;
  final User user;

  ShowProduct({required this.product_id, required this.user, this.favorite_id});

  @override
  _ShowProduct createState() => _ShowProduct();
}

class _ShowProduct extends State<ShowProduct> {
  bool isFavorite = false;
  ProductModel? _product;
  int? currentFavoriteId; // لتخزين معرف المفضلة الحالي

  @override
  void initState() {
    super.initState();
    isFavorite = widget.favorite_id != null;
    currentFavoriteId = widget.favorite_id;
  }

  Future<void> _toggleFavorite() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));

      if (isFavorite) {
        // إذا كان المنتج مفضلاً، نقوم بحذفه
        if (currentFavoriteId != null) {
          await favoritApi.deleteFavorit(currentFavoriteId!);
        }
      } else {
        // إذا لم يكن المنتج مفضلاً، نضيفه إلى المفضلة
        final newFavorite = await favoritApi.addFavorit(Favorit(
          id: 0, // سيتم تجاهله من الخادم
          user_id: widget.user.id,
          product_id: widget.product_id,
          state: 1,
        ));
        currentFavoriteId = newFavorite.id;
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: ProductBody(
        product_id: widget.product_id,
        onProductLoaded: (product) {
          setState(() {
            _product = product;
          });
        },
      ),
      floatingActionButton: _product == null
          ? SizedBox()
          : RawMaterialButton(
        onPressed: _toggleFavorite,
        fillColor: isFavorite ? Colors.white : color_main,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: color_main,
            width: 2,
          ),
        ),
        constraints: BoxConstraints.tightFor(width: 56, height: 56),
        elevation: 4,
        child: Icon(
          Icons.favorite,
          color: isFavorite ? color_main : Colors.white,
        ),
      ),
    );
  }
}