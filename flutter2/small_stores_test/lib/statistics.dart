import 'package:flutter/material.dart';
import 'package:small_stores_test/showproductdata.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class Statistics extends StatefulWidget {
  @override
  _Statistics createState() => _Statistics();
}

class _Statistics extends State<Statistics> {
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
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        children: [
                          // حقل البحث
                          TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: a_store_name_s,
                              suffixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
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
                                    'كل المتاجر',
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
                                        MaterialPageRoute(builder: (context) => ShowProfileData()),
                                      );
                                    },
                                child: Card(
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

                                      // اسم المتجر
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child:
                                          Text(
                                            'اسم المنتج',
                                            style: style_text_normal_w,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                );
                              }
                              ),
                            ),
                          ),
                        ]
                    )
                )
            )
        )
    );
  }
}