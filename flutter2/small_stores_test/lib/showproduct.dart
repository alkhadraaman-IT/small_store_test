import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'product.dart';
import 'style.dart';
import 'variables.dart';

class ShowProduct extends StatefulWidget {
  @override
  _ShowProduct createState() => _ShowProduct();
}

class _ShowProduct extends State<ShowProduct> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: ProductBody(productId: 1), // أو ID المنتج اللي بدك تعرضه

      floatingActionButton: RawMaterialButton(
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite;
          });
        },
        fillColor: isFavorite ? Colors.white : color_main,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // شكل مستطيل بحواف ناعمة
          side: BorderSide(
            color: color_main,
            width: 2,
          ),
        ),
        constraints: BoxConstraints.tightFor(width: 56, height: 56), // حجم الزر
        elevation: 4,
        child: Icon(
          Icons.favorite,
          color: isFavorite ? color_main : Colors.white,
        ),
    ),
    );
  }
}