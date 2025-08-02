import 'package:flutter/material.dart';
import 'package:small_stores_test/product.dart';

import 'addproduct.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class ProductAll extends StatefulWidget {
  @override
  _ProductAll createState() => _ProductAll();
}

class _ProductAll extends State<ProductAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: ProductAllBody(), // ✅ لا حاجة لـ SingleChildScrollView
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}

class ProductAllBody extends StatefulWidget {
  @override
  _ProductAllBody createState() => _ProductAllBody();
}

class _ProductAllBody extends State<ProductAllBody> {
  final TextEditingController _searchController = TextEditingController();

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
          // 🔍 حقل البحث
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
          ),

          SizedBox(height: 16),

          // 🏷️ عنوان القسم
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'المنتجات',
                style: style_text_titel,
              ),
            ),
          ),

          SizedBox(height: 16),

          // 🧱 الشبكة
          Expanded( // ✅ تعمل الآن لأننا لسنا داخل ScrollView
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Product()),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // 📷 الصورة
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/images/shirt.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // 🌑 التدرج
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

                        // 🏷️ الاسم والسعر
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'اسم المنتج',
                                  style: style_text_normal_w,
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  '200 \$',
                                  style: style_text_normal_w,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
