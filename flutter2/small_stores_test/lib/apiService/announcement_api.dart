import '../models/announcementmodel.dart';
import 'api_service.dart';

class AnnouncementApi {
  final ApiService apiService;

  AnnouncementApi({required this.apiService});

  // عرض مستخدم واحد
  Future<Announcement> getAnnouncement(int id) async {
    final data = await apiService.get('announcements/$id');
    return Announcement.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<Announcement>> getAnnouncements() async {
    final data = await apiService.get('announcements');
    return (data as List).map((announcement) => Announcement.fromJson(announcement)).toList();
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

    final data = await apiService.post('announcements', announcementData);
    return Announcement.fromJson(data);
  }


  // تعديل مستخدم
  Future<Announcement> updateAnnouncement(int id, Announcement announcement) async {
    final data = await apiService.put('announcements/$id', announcement.toJson());
    return Announcement.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteAnnouncement(int id) async {
    await apiService.put('announcements/$id/delete', {'state': 0});
  }
}