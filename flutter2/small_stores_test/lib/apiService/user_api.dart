import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/usermodel.dart';
import 'api_service.dart';

class UserApi {
  final ApiService apiService;

  UserApi({required this.apiService});

  // عرض مستخدم واحد
  Future<User> getUser(int id) async {
    final data = await apiService.get('users/view/$id');
    return User.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<User>> getUsers() async {
    try {
      final data = await apiService.get('users/view');
      print('API Response: $data'); // أضف هذا السطر
      return (data as List).map((user) => User.fromJson(user)).toList();
    } catch (e) {
      print('Error in getUsers: $e');
      throw Exception('Failed to load users');
    }
  }
/*
  // إضافة مستخدم جديد
  Future<User> addUser(User user) async {
    final data = await apiService.post('users', user.toJson());
    return User.fromJson(data);
  }
*/
  /// إضافة مستخدم جديد (النسخة المعدلة)
  // تغيير نوع الإرجاع ليكون Map مثل AuthService.login
  // في دالة addUser في UserApi
  Future<Map<String, dynamic>> addUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final userData = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'user': data['user'],
          'access_token': data['access_token'],
        };
      } else {
        // إرجاع رسالة الخطأ من السيرفر
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ??
            errorData['errors']?.toString() ??
            'فشل في إنشاء الحساب: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // تعديل مستخدم
  Future<User> updateUser({
    required int id,
    required String name,
    required String email,
    required String phone,
    String? password,
    int type = 1,
    int status = 1,
    File? profilePhoto,      // للموبايل
    Uint8List? profileBytes, // للويب
  }) async {
    final token = await apiService.getToken();
    final uri = Uri.parse("${ApiService.baseUrl}/users/update/$id");

    var request = http.MultipartRequest('POST', uri);
    request.fields['_method'] = 'PATCH';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.fields['type'] = type.toString();
    request.fields['status'] = status.toString();

    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
    }

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (!kIsWeb && profilePhoto != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_photo',
        profilePhoto.path,
      ));
    }

    if (kIsWeb && profileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'profile_photo',
        profileBytes,
        filename: "profile.png",
      ));
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(respStr);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception("فشل تعديل المستخدم: ${response.statusCode}, $respStr");
    }
  }


// حذف مستخدم (تعديل الحقل state)
  Future<void> deleteUser(int id) async {
    await apiService.patch('users/delete/$id', {'state': 0});
  }
}