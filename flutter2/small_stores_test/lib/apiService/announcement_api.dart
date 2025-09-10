import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/announcementmodel.dart';
import 'api_service.dart';

class AnnouncementApi {
  final ApiService apiService;

  AnnouncementApi({required this.apiService});

  // عرض إعلان واحد
  Future<Announcement> getAnnouncement(int id) async {
    final data = await apiService.get('announcement/view/$id');
    return Announcement.fromJson(data);
  }

  // عرض جميع الإعلانات
  Future<List<Announcement>> getAnnouncements() async {
    final data = await apiService.get('announcement/view');
    final List<dynamic> announcementsJson = data['data'];
    return announcementsJson
        .map((announcement) => Announcement.fromJson(announcement))
        .toList();
  }

  // عرض إعلانات مستخدم معين
  Future<List<Announcement>> getMyAnnouncements(int id) async {
    final response = await apiService.get('announcement/view/user/$id');
    final announcementsData = response['data'] as List;
    return announcementsData
        .map((announcement) => Announcement.fromJson(announcement))
        .toList();
  }

  // إضافة إعلان جديد (Web & Mobile)
  Future<Announcement> addAnnouncement({
    required int store_id,
    required String announcement_description,
    required String announcement_date,
    int announcement_state = 1, // رقم صحيح
    File? announcementPhotoFile, // للموبايل
    Uint8List? announcementPhotoBytes, // للويب
    String fileName = 'announcement.jpg',
  }) async {
    final token = await apiService.getToken();
    final uri = Uri.parse('${ApiService.baseUrl}/announcement/add');
    var request = http.MultipartRequest('POST', uri);

    // الحقول العادية
    request.fields['store_id'] = store_id.toString();
    request.fields['announcement_description'] = announcement_description;
    request.fields['announcement_date'] = announcement_date;
    request.fields['announcement_state'] = announcement_state.toString(); // تحويل int إلى String

    // إضافة التوكن
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // رفع الصورة
    if (!kIsWeb && announcementPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'announcement_photo',
        announcementPhotoFile.path,
      ));
    } else if (kIsWeb && announcementPhotoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'announcement_photo',
        announcementPhotoBytes,
        filename: fileName,
      ));
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(respStr);
      return Announcement.fromJson(jsonResponse['data']);
    } else {
      throw Exception('فشل رفع الإعلان: ${response.statusCode}, $respStr');
    }
  }

// تعديل إعلان (Web & Mobile)
  Future<Announcement> updateAnnouncement({
    required int id,
    required int store_id,
    required String announcement_description,
    required String announcement_date,
    int announcement_state = 1, // رقم صحيح
    File? announcementPhotoFile, // للموبايل
    Uint8List? announcementPhotoBytes, // للويب
    String fileName = 'announcement.jpg',
  }) async {
    final token = await apiService.getToken();
    final uri = Uri.parse('${ApiService.baseUrl}/announcement/update/$id');
    var request = http.MultipartRequest('POST', uri);

    request.fields['_method'] = 'PATCH';

    // الحقول العادية
    request.fields['store_id'] = store_id.toString();
    request.fields['announcement_description'] = announcement_description;
    request.fields['announcement_date'] = announcement_date;
    request.fields['announcement_state'] = announcement_state.toString(); // تحويل int إلى String

    // إضافة التوكن
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // رفع الصورة إذا موجودة
    if (!kIsWeb && announcementPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'announcement_photo',
        announcementPhotoFile.path,
      ));
    }

    if (kIsWeb && announcementPhotoBytes != null) {
      // تحويل List<int> إلى Uint8List إذا كانت لديك قائمة من الأرقام
      final Uint8List bytes = announcementPhotoBytes is Uint8List
          ? announcementPhotoBytes
          : Uint8List.fromList(announcementPhotoBytes);
      request.files.add(http.MultipartFile.fromBytes(
        'announcement_photo',
        bytes,
        filename: fileName,
      ));
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(respStr);
      return Announcement.fromJson(jsonResponse['data']);
    } else {
      throw Exception('فشل تعديل الإعلان: ${response.statusCode}, $respStr');
    }
  }


  // حذف إعلان (تغيير الحالة فقط)
  Future<void> deleteAnnouncement(int id) async {
    await apiService.patch('announcement/delete/$id', {'state': 0});
  }
}
