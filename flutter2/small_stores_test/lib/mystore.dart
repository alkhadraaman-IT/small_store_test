import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/addstore.dart';
import 'package:small_stores_test/showstoredata.dart';

import 'apiService/api_service.dart';
import 'apiService/store_api.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'showmystoredata.dart';
import 'style.dart';
import 'variables.dart';

class MyStore extends StatefulWidget {
  final User user;

  const MyStore({Key? key, required this.user}) : super(key: key);

  @override
  _MyStore createState() => _MyStore();
}

class _MyStore extends State<MyStore> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStoreBody(user: widget.user), // ✅ مرر الـ user_id
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStore(user: widget.user,)),
          );
        },
        child: Icon(Icons.add,color: Colors.white,), // أو أيقونة أخرى مثل Icons.edit
        backgroundColor: color_main, // لون الزر (اختياري)
      ),
    );
  }
}

class MyStoreBody extends StatefulWidget {
  final User user;
  final bool page_view; // المتغير الجديد للتحكم في العرض

  const MyStoreBody({Key? key, required this.user,this.page_view=true}) : super(key: key);

  @override
  _MyStoreBody createState() => _MyStoreBody();
}

class _MyStoreBody extends State<MyStoreBody> {
  final TextEditingController _searchController = TextEditingController();

  List<StoreModel> _allStores = [];
  List<StoreModel> _filteredStores = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStores();
    _searchController.addListener(_filterStores);
  }

  void _loadStores() async {
    try {
      final stores = await StoreApi(
        apiService: ApiService(client: http.Client()),
      ).getStoresUser(widget.user.id);

      setState(() {
        _allStores = stores;
        _filteredStores = stores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في جلب البيانات';
        _isLoading = false;
      });
    }
  }

  void _filterStores() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStores = _allStores.where((store) {
        final nameMatch = store.store_name.toLowerCase().contains(query);
        final placeMatch = store.store_place.toLowerCase().contains(query);
        return nameMatch || placeMatch;
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
              ),
              SizedBox(height: 16),

              // العنوان
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('متاجري', style: style_text_titel),
                ),
              ),
              SizedBox(height: 16),

              // عرض البيانات
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : _filteredStores.isEmpty
                    ? Center(child: Text('لا توجد متاجر متاحة'))
                    : GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _filteredStores.length,
                  itemBuilder: (context, index) {
                    final store = _filteredStores[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowMyStoreData(
                              store: store,
                              user: widget.user,
                              page_view: widget.page_view,
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
                            // صورة المتجر
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: store.store_photo.isNotEmpty
                                      ? NetworkImage(
                                      store.store_photo)
                                      : AssetImage(
                                      'assets/images/default_store.png')
                                  as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // التدرج
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(12),
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
                            // معلومات المتجر
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
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
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        store.store_place,
                                        style: style_text_normal_w
                                            .copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
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
        ),
      ),
    );
  }
}
