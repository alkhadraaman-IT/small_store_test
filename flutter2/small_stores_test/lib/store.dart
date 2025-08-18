import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/editstore.dart';
import 'addannouncement.dart';
import 'apiService/api_service.dart';
import 'apiService/class_api.dart';
import 'apiService/store_api.dart';
import 'drawer.dart';
import 'models/classmodel.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'variables.dart'; // تأكد من أن هذا الملف يحتوي على المتغير app_name
import 'style.dart'; // إذا كنت تستخدم ملف style.dart لتخصيص الأنماط
import 'appbar.dart'; // إذا كنت تستخدم ملف style.dart لتخصيص الأنماط

class Store extends StatefulWidget {
  final int store_id;
  final User user;

  const Store({Key? key, required this.store_id,required this.user}) : super(key: key);

  @override
  _Store createState() => _Store();
}

class _Store extends State<Store> {
  StoreModel? _store;
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoreBody(
            store_id: widget.store_id,
            onStoreLoaded: (store) {
              setState(() {
                _store = store;
              });
            },
          ),

        if (showOptions)
    Positioned(
      bottom: 80,
      left: 20,
      child: Column(
        children: [
          // زر التعديل
          SizedBox(
            width: 50,
            height: 50,
            child: Material(
              elevation: 5, // الظل
              borderRadius: BorderRadius.circular(8),
              child: OutlinedButton(
                onPressed: () {
                  setState(() => showOptions = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditStore(store: _store!, user: widget.user)),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(Icons.edit, color: color_main),
              ),
            ),
          ),
          SizedBox(height: 10),
          // زر الإعلان
          SizedBox(
            width: 50,
            height: 50,
            child: Material(
              elevation: 5, // الظل
              borderRadius: BorderRadius.circular(8),
              child: OutlinedButton(
                onPressed: () {
                  setState(() => showOptions = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddAnnouncement(user: widget.user, store_id: widget.store_id)),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(Icons.campaign, color: color_main),
              ),
            ),
          ),
          SizedBox(height: 10),
          // زر الحذف
          SizedBox(
            width: 50,
            height: 50,
            child: Material(
              elevation: 5, // الظل
              borderRadius: BorderRadius.circular(8),
              child: OutlinedButton(
                onPressed: () async {
                  setState(() => showOptions = false);

                  bool confirm = await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('تأكيد الحذف'),
                      content: Text('هل أنت متأكد من حذف هذا المتجر؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('حذف', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm) {
                    try {
                      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
                      await storeApi.deleteStore(_store!.id);
                      Navigator.pop(context); // العودة للشاشة السابقة بعد الحذف
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('فشل حذف المتجر: $e')),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    ),
    ]),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showOptions = !showOptions;
          });
        },
        child: Icon(Icons.more_vert, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}


class StoreBody extends StatefulWidget {
  final int store_id;

  final Function(StoreModel) onStoreLoaded;

  StoreBody({required this.store_id, required this.onStoreLoaded});

  @override
  _StoreBody createState() => _StoreBody();
}


class _StoreBody extends State<StoreBody> {
  StoreModel? _store;
  List<ClassModel> _classes = []; // 🔥 ضفنا هذا السطر هنا
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchStore();
  }

  Future<void> fetchStore() async {
    try {
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      final stores = await storeApi.getStores();

      final classApi = ClassApi(apiService: ApiService(client: http.Client()));
      final classList = await classApi.getClasses();

      final selectedStore = stores.firstWhere((s) => s.id == widget.store_id); // ✅ هون التعديل

      setState(() {
        _store = selectedStore;
        _classes = classList;
        _isLoading = false;
      });

      widget.onStoreLoaded(_store!); // تمرير المتجر للأب

    } catch (e) {
      print('خطأ في جلب بيانات المتجر: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    //  هنا تحط السطر لتحديد اسم الصنف المناسب:
    String className = _classes.firstWhere(
          (c) => c.id == _store!.class_id,
      orElse: () => ClassModel(id: 0, class_name: "غير معروف"),
    ).class_name;

    return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // لمحاذاة النصوص يمينًا
                children: [
                  Image.network(_store!.store_photo,height: 60,width: 60,),
                  SizedBox(height: 16),
                  Text(
                    '${a_store_name_s}: ${_store!.store_name}',
                    style: style_text_normal,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${a_store_plane_s}: ${_store!.store_place}',
                    style: style_text_normal,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${a_store_phone_s}: ${_store!.store_phone}',
                    style: style_text_normal,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${a_store_class_s}: $className',
                    style: style_text_normal,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${a_store_note_s}: ${_store!.store_description}',
                    style: style_text_normal,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
  }
}