import 'package:flutter/material.dart';
import 'package:small_stores_test/showproduct.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'product.dart';
import 'style.dart';
import 'variables.dart';

class Favorite extends StatefulWidget {
  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
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
                      ),

                      SizedBox(height: 16),
                      // العنوان الرئيسي
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child:Text(
                                a_favort_s,
                                style: style_text_titel,
                              )
                          )
                      ),

                      SizedBox(height: 16),

                      // شبكة المتاجر
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: List.generate(6, (index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ShowProduct()),
                                  );
                                },child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  // الصورة
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/shirt.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // التدرج فوق الصورة
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

                                  //اسم المنتج والسعر
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child:Row(
                                            children:[
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
                                            ]
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          }
                          ),
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}