import 'package:flutter/material.dart';
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
import 'variables.dart';
import 'style.dart';

class Store extends StatefulWidget {
  final int store_id;
  final User user;

  const Store({Key? key, required this.store_id, required this.user})
      : super(key: key);

  @override
  _Store createState() => _Store();
}

class _Store extends State<Store> {
  StoreModel? _store;
  bool showOptions = false;

  // تأكيد الحذف بخطوتين
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    bool firstConfirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تأكيد الحذف', style: style_text_titel),
        content: Text('هل تريد حذف هذا المتجر؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء',
                style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('نعم', style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (firstConfirm == true) {
      bool finalConfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('تأكيد نهائي', style: style_text_titel),
          content: Text(
              'هل أنت متأكد من أنك تريد حذف هذا المتجر؟ لا يمكن التراجع عن هذه العملية.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('إلغاء',
                  style: style_text_button_normal_2(color_Secondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('تأكيد الحذف', style: style_text_button_normal_red),
            ),
          ],
        ),
      );

      if (finalConfirm == true) {
        _deleteStore();
      }
    }
  }

  // حذف المتجر
  Future<void> _deleteStore() async {
    try {
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      await storeApi.deleteStore(_store!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف المتجر بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف المتجر: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreBody(
        store_id: widget.store_id,
        onStoreLoaded: (store) {
          setState(() {
            _store = store;
          });
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_store != null && showOptions) ...[
            // زر التعديل
            FloatingActionButton(
              heroTag: "editStoreBtn",
              onPressed: () {
                setState(() => showOptions = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditStore(store: _store!, user: widget.user),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.edit, color: color_main),
            ),
            SizedBox(height: 10),

            // زر الإعلان
            FloatingActionButton(
              heroTag: "addAnnouncementBtn",
              onPressed: () {
                setState(() => showOptions = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAnnouncement(
                      user: widget.user,
                      store_id: widget.store_id,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.campaign, color: color_main),
            ),
            SizedBox(height: 10),

            // زر الحذف
            FloatingActionButton(
              heroTag: "deleteStoreBtn",
              onPressed: () {
                setState(() => showOptions = false);
                _showDeleteConfirmation(context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.delete, color: Colors.red),
            ),
            SizedBox(height: 10),
          ],

          // زر المزيد
          FloatingActionButton(
            heroTag: "moreOptionsBtn",
            onPressed: () {
              setState(() {
                showOptions = !showOptions;
              });
            },
            backgroundColor: color_main,
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
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
  List<ClassModel> _classes = [];
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

      final selectedStore =
      stores.firstWhere((s) => s.id == widget.store_id);

      setState(() {
        _store = selectedStore;
        _classes = classList;
        _isLoading = false;
      });

      widget.onStoreLoaded(_store!);
      print("📸 store_photo = '${_store!.store_photo}'");

    } catch (e) {
      print('خطأ في جلب بيانات المتجر: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    String className = _classes.firstWhere(
          (c) => c.id == _store!.class_id,
      orElse: () => ClassModel(id: 0, class_name: "غير معروف"),
    ).class_name;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.network(
                  _store!.store_photo.isNotEmpty
                      ? _store!.store_photo
                      : 'https://via.placeholder.com/140',
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder.png',
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
    Image.network(
    _store!.store_photo.isNotEmpty
    ? _store!.store_photo
        : 'https://via.placeholder.com/140',
    height: 140,
    width: 140,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
    return Image.asset(
    'assets/images/img5.png',
    height: 140,
    width: 140,
    fit: BoxFit.cover,
    );},
    ),
            SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.store,color: color_main, size: 24),
            SizedBox(width: 10),
            Text(
             // '${a_store_name_s}:'
                  ' ${_store!.store_name}',
              style: style_text_normal,
            ),
          ]
        ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.place,color: color_main ,size: 24),
                SizedBox(width: 10),
                Text(
                  '${a_store_plane_s}: ${_store!.store_place}',
                  style: style_text_normal,
                ),
              ],
            ),
            SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.phone,color: color_main ,size: 24),
            SizedBox(width: 10),
            Text(
              '${a_store_phone_s}: ${_store!.store_phone}',
              style: style_text_normal,
            ),]),
            SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.type_specimen,color: color_main ,size: 24),
            SizedBox(width: 10),
            Text(
              '${a_store_class_s}: $className',
              style: style_text_normal,
            ),]),
            SizedBox(height: 16),
            Text(
              '${a_store_note_s}:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              //'${a_store_note_s}:'
                  ' ${_store!.store_description}',
              style: style_text_normal,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
