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
import 'variables.dart'; // تأكد من أن هذا الملف يحتوي على المتغير app_name
import 'style.dart'; // إذا كنت تستخدم ملف style.dart لتخصيص الأنماط
import 'appbar.dart'; // إذا كنت تستخدم ملف style.dart لتخصيص الأنماط

class Store extends StatefulWidget {
  @override
  _Store createState() => _Store();
}

class _Store extends State<Store> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoreBody(), // صار بدون Scaffold بداخله

          // الزرين المنبثقين
          if (showOptions)
            Positioned(
              bottom: 80,
              left: 20,
              child: Column(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => showOptions = false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditStore()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: color_main, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.edit, color: color_main),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => showOptions = false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddAnnouncement()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: color_main, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.campaign, color: color_main),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
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

      if (stores.isEmpty) {
        print(' لا يوجد متاجر');
        return;
      }

      setState(() {
        _store = stores.first;
        _classes = classList;
        _isLoading = false;
      });
    } catch (e) {
      print(' خطأ في جلب بيانات المتجر: $e');
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

                //crossAxisAlignment: CrossAxisAlignment.start, // لمحاذاة النصوص إلى اليسار
                children: [
                  Image.network(_store!.store_photo),
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