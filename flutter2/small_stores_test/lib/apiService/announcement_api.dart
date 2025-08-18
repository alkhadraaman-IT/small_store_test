import '../models/announcementmodel.dart';
import 'api_service.dart';

class AnnouncementApi {
  final ApiService apiService;

  AnnouncementApi({required this.apiService});

  // عرض مستخدم واحد
  Future<Announcement> getAnnouncement(int id) async {
    final data = await apiService.get('announcement/view/$id');
    return Announcement.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<Announcement>> getAnnouncements() async {
    final data = await apiService.get('announcement/view');

    // نتحقق أن البيانات تحتوي على مفتاح 'data'
    final List<dynamic> announcementsJson = data['data'];

    return announcementsJson
        .map((announcement) => Announcement.fromJson(announcement))
        .toList();
  }

  Future<List<Announcement>> getMyAnnouncements(int id) async {
    final response = await apiService.get('announcement/view/user/$id');

    final announcementsData = response['data'] as List; // هنا نأخذ محتوى data
    return announcementsData.map((announcement) => Announcement.fromJson(announcement)).toList();
  }


  /*
  // إضافة مستخدم جديد
  Future<Announcement> addAnnouncement(Announcement announcement) async {
    final data = await apiService.post('announcements', announcement.toJson());
    return Announcement.fromJson(data);
  }*/
  /// إضافة مستخدم جديد (النسخة المعدلة)
  Future<Announcement> addAnnouncement({
    required int store_id,
    required String announcement_description,
    required String announcement_date,
    bool announcement_state= true,
    required String announcement_photo,
  }) async {
    final announcementData = {
      'store_id': store_id,
      'announcement_description': announcement_description,
      'announcement_date': announcement_date,
      'announcement_state': announcement_state,
      'announcement_photo': announcement_photo,
    };

    final data = await apiService.post('announcement/add', announcementData);
    return Announcement.fromJson(data);
  }


  // تعديل مستخدم
  Future<Announcement> updateAnnouncement({
    required int id,
    required int store_id,
    required String announcement_description,
    required String announcement_date,
    bool announcement_state = true,
    required String announcement_photo,
  }) async {
    final announcementData = {
      'store_id': store_id,
      'announcement_description': announcement_description,
      'announcement_date': announcement_date,
      'announcement_state': announcement_state,
      'announcement_photo': announcement_photo,
    };

    final data = await apiService.patch('announcement/update/$id', announcementData);
    return Announcement.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteAnnouncement(int id) async {
    await apiService.patch('announcement/delete/$id', {'state': 0});
  }
}