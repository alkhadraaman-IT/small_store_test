import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/showstoredata.dart';
import 'package:small_stores_test/style.dart';
import 'apiService/api_service.dart';
import 'apiService/store_api.dart';
import 'apiService/class_api.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'models/classmodel.dart';
import 'variables.dart';

class Home extends StatefulWidget {
  final User user;

  Home({Key? key, required this.user}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<StoreModel>> futureStores;
  late Future<List<ClassModel>> futureCategories;

  List<StoreModel> allStores = [];
  List<StoreModel> filteredStores = [];
  List<ClassModel> categories = [];

  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    futureStores = StoreApi(apiService: ApiService(client: http.Client())).getStores();
    futureCategories = ClassApi(apiService: ApiService(client: http.Client())).getClasses();

    _loadData();
  }

  Future<void> _loadData() async {
    allStores = await futureStores;
    categories = await futureCategories;
    filteredStores = List.from(allStores);
    setState(() {});
  }

  void _applyFilters() {
    setState(() {
      filteredStores = allStores.where((store) {
        final matchesSearch = store.store_name.contains(_searchController.text);
        final matchesCategory =
            selectedCategoryId == null || store.class_id == selectedCategoryId;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  IconData _getCategoryIcon(String className) {
    switch (className) {
      case 'زينة حفلات':
        return Icons.celebration;
      case 'برمجة':
        return Icons.code;
      case 'ملبوسات':
        return Icons.checkroom;
      case 'مواد طبيعية':
        return Icons.spa;
      case 'اعمال يدوية':
        return Icons.handyman;
      case 'غذائيات':
        return Icons.fastfood;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) => _applyFilters(),
              ),
              SizedBox(height: 16),

              // أزرار الفئات
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // زر عرض الكل
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = null;
                            _applyFilters();
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: selectedCategoryId == null
                                ? Colors.white
                                : color_main,
                            border: Border.all(
                              color: color_main,
                              width: selectedCategoryId == null ? 2 : 0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.all_inclusive,
                            color: selectedCategoryId == null
                                ? color_main
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    for (var category in categories)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
                              _applyFilters();
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: selectedCategoryId == category.id
                                  ? Colors.white
                                  : color_main,
                              border: Border.all(
                                color: color_main,
                                width:
                                selectedCategoryId == category.id ? 2 : 0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCategoryIcon(category.class_name),
                              color: selectedCategoryId == category.id
                                  ? color_main
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // العنوان الرئيسي
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'كل المتاجر',
                    style: style_text_titel,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // شبكة المتاجر
              Expanded(
                child: allStores.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : filteredStores.isEmpty
                    ? Center(child: Text('لا يوجد متاجر حالياً'))
                    : GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: filteredStores.map((store) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowStoreData(
                                store: store, user: widget.user),
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
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      store.store_photo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.store_name,
                                      style: style_text_normal_w
                                          .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          store.store_place,
                                          style:
                                          style_text_normal_w.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
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
