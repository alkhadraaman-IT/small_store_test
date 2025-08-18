import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/store.dart';
import 'package:small_stores_test/variables.dart';
import 'apiService/api_service.dart';
import 'apiService/announcement_api.dart';
import 'apiService/store_api.dart'; // تأكد من استيراد StoreApi
import 'models/announcementmodel.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'showstoredata.dart';
import 'style.dart'; // تأكد من استيراد StoreModel

class AnnouncementScreen extends StatefulWidget {
  final User user;

  const AnnouncementScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AnnouncementScreen createState() => _AnnouncementScreen();
}

class _AnnouncementScreen extends State<AnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Announcement> _announcements = [];
  Map<int, StoreModel> _storesCache = {}; // ذاكرة تخزين مؤقت لمعلومات المتاجر
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final api = AnnouncementApi(apiService: ApiService(client: http.Client()));
      final fetched = await api.getAnnouncements();

      // جلب معلومات المتاجر لكل إعلان
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      for (var announcement in fetched) {
        if (!_storesCache.containsKey(announcement.store_id)) {
          final store = await storeApi.getStore(announcement.store_id);
          _storesCache[announcement.store_id] = store;
        }
      }

      setState(() {
        _announcements = fetched;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في جلب الإعلانات: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              a_ann_d,
              style: style_text_titel,
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _announcements.isEmpty
                  ? Center(child: Text('لا توجد إعلانات حالياً'))
                  : ListView.builder(
                itemCount: _announcements.length,
                itemBuilder: (context, index) {
                  final item = _announcements[index];
                  final store = _storesCache[item.store_id];

                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // الخلفية - صورة الإعلان مع تدرج
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item.announcement_photo),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // المحتوى في الأسفل
                        Positioned(
                          bottom: 12,
                          right: 12,
                          left: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final clickedStore = store; // المتجر الذي ضغط عليه المستخدم
                                        if (clickedStore != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ShowStoreData(
                                                store: clickedStore,
                                                user: widget.user,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: store != null && store.store_photo.isNotEmpty
                                            ? NetworkImage(store.store_photo)
                                            : AssetImage('assets/images/logo.png') as ImageProvider,
                                        radius: 16,
                                      ),
                                    ),

                                    SizedBox(width: 8),
                                    Text(
                                      store?.store_name ?? 'متجر ${item.store_id}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item.announcement_description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 4),
                              Text(
                                item.announcement_date,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}