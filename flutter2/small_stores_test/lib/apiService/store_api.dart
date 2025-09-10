import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/storemodel.dart';
import 'api_service.dart';

class StoreApi {
  final ApiService apiService;

  StoreApi({required this.apiService});

  // عرض متجر واحد
  Future<StoreModel> getStore(int id) async {
    final data = await apiService.get('stores/view/$id');
    return StoreModel.fromJson(data);
  }

  // عرض جميع المتاجر
  Future<List<StoreModel>> getStores() async {
    final data = await apiService.get('stores/view');
    return (data as List).map((store) => StoreModel.fromJson(store)).toList();
  }

  // عرض متاجر مستخدم معين
  Future<List<StoreModel>> getStoresUser(int id) async {
    try {
      final response = await apiService.get('stores/view/user/$id');

      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          final data = response['data'];
          if (data is List) {
            return data.map((store) => StoreModel.fromJson(store)).toList();
          } else if (data is Map<String, dynamic>) {
            return [StoreModel.fromJson(data)];
          } else {
            throw Exception('تنسيق بيانات غير متوقع في حقل data');
          }
        } else {
          throw Exception(response['message'] ?? 'فشل جلب المتاجر');
        }
      }

      throw Exception('تنسيق استجابة غير متوقع من الخادم');
    } catch (e) {
      print('Error in getStoresUser: $e');
      throw Exception('فشل تحميل المتاجر للمستخدم $id: ${e.toString()}');
    }
  }

  // إضافة متجر جديد
  Future<StoreModel> addStore({
    required int user_id,
    required String store_name,
    required String store_phone,
    required String store_place,
    required int class_id,
    required String store_description,
    int store_state = 1,
    File? store_photo, // للموبايل
    List<int>? storePhotoBytes, // للويب
  }) async {
    final token = await apiService.getToken();
    final uri = Uri.parse("${ApiService.baseUrl}/stores/add");

    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = user_id.toString();
    request.fields['store_name'] = store_name;
    request.fields['store_phone'] = store_phone;
    request.fields['store_place'] = store_place;
    request.fields['class_id'] = class_id.toString();
    request.fields['store_description'] = store_description;
    request.fields['store_state'] = store_state.toString();

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (store_photo != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'store_photo',
        store_photo.path,
      ));
    } else if (storePhotoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'store_photo',
        storePhotoBytes,
        filename: "upload.png",
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(respStr);
      return StoreModel.fromJson(jsonResponse);
    } else {
      final respStr = await response.stream.bytesToString();
      throw Exception("فشل رفع المتجر: ${response.statusCode}, $respStr");
    }
  }

  // تعديل متجر
  Future<StoreModel> updateStore({
    required int id,
    required String store_name,
    required String store_phone,
    required String store_place,
    required int class_id,
    required String store_description,
    int store_state = 1,
    File? store_photo, // موبايل
    Uint8List? storePhotoBytes, // ويب
  }) async {
    final token = await apiService.getToken();
    final uri = Uri.parse("${ApiService.baseUrl}/stores/update/$id");

    var request = http.MultipartRequest('POST', uri);
    request.fields['_method'] = 'PATCH';

    request.fields['store_name'] = store_name;
    request.fields['store_phone'] = store_phone;
    request.fields['store_place'] = store_place;
    request.fields['class_id'] = class_id.toString();
    request.fields['store_description'] = store_description;
    request.fields['store_state'] = store_state.toString();

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (!kIsWeb && store_photo != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'store_photo',
        store_photo.path,
      ));
    }

    if (kIsWeb && storePhotoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'store_photo',
        storePhotoBytes,
        filename: "upload.png",
      ));
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(respStr);
      return StoreModel.fromJson(jsonResponse);
    } else {
      throw Exception("فشل تعديل المتجر: ${response.statusCode}, $respStr");
    }
  }

  // حذف متجر (تغيير الحالة فقط)
  Future<void> deleteStore(int id) async {
    await apiService.patch('stores/delete/$id', {'state': 0});
  }
}
