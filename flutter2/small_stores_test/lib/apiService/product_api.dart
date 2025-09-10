import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // إضافة هذا الاستيراد

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/productmodel.dart';
import 'api_service.dart';

class ProductApi {
  final ApiService apiService;

  ProductApi({required this.apiService});
// دالة مساعدة للحصول على headers مع التوكن
  Future<Map<String, String>> _getHeaders() async {
    final headers = {'Content-Type': 'application/json'};

    // استخدام الـ getter الجديد
    final token = await apiService.getToken();

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // دالة مساعدة لـ multipart headers
  Future<Map<String, String>> _getMultipartHeaders() async {
    final headers = await _getHeaders();
    headers['Content-Type'] = 'multipart/form-data';
    return headers;
  }

  // عرض مستخدم واحد
  Future<ProductModel> getProduct(int id) async {
    final data = await apiService.get('products/view/$id');
    return ProductModel.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<ProductModel>> getProducts(int id) async {
    final data = await apiService.get('products/view/stores/$id');
    return (data as List).map((product) => ProductModel.fromJson(product)).toList();
  }

  /*// إضافة مستخدم جديد
  Future<Product> addProduct(Product product) async {
    final data = await apiService.post('products', product.toJson());
    return Product.fromJson(data);
  }*/
  /// إضافة منتج جديد (النسخة المعدلة)
  Future<ProductModel> addProduct({
    required int store_id,
    required String product_name,
    required int type_id,
    required String product_description,
    required String product_price,
    int product_available = 1,
    int product_state = 1,
    required Uint8List product_photo_1,
    Uint8List? product_photo_2,
    Uint8List? product_photo_3,
    Uint8List? product_photo_4,
  }) async {
    print('URL: ${ApiService.baseUrl}/products/add');
    var uri = Uri.parse('${ApiService.baseUrl}/products/add');
    var request = http.MultipartRequest('POST', uri);

    // الحصول على headers مع التوكن
    final headers = await _getMultipartHeaders();
    request.headers.addAll(headers);

    request.fields['store_id'] = store_id.toString();
    request.fields['product_name'] = product_name;
    request.fields['type_id'] = type_id.toString();
    request.fields['product_description'] = product_description;
    request.fields['product_price'] = product_price;
    request.fields['product_available'] = product_available.toString();
    request.fields['product_state'] = product_state.toString();

    request.files.add(http.MultipartFile.fromBytes(
      'product_photo_1',
      product_photo_1,
      filename: 'product_1.jpg',
    ));

    if (product_photo_2 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_2',
        product_photo_2,
        filename: 'product_2.jpg',
      ));
    }
    if (product_photo_3 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_3',
        product_photo_3,
        filename: 'product_3.jpg',
      ));
    }
    if (product_photo_4 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_4',
        product_photo_4,
        filename: 'product_4.jpg',
      ));
    }

    // أضف طباعة للتحقق من headers
    print('Request Headers: ${request.headers}');

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');

    if (response.body.isNotEmpty) {
      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        print('Full JSON response: $jsonData');

        // تحقق من structure الـ JSON
        if (jsonData.containsKey('product')) {
          print('Product object: ${jsonData['product']}');
          print('Store_id type: ${jsonData['product']['store_id'].runtimeType}');
          print('Type_id type: ${jsonData['product']['type_id'].runtimeType}');
        }
        print('Full response: ${response.body}');

        return ProductModel.fromJson(jsonData);
      }
      if (response.body.length > 500) {
        print('First 500 chars of response: ${response.body.substring(0, 500)}');
      } else {
        print('Full response: ${response.body}');
      }
    }

    if (response.statusCode == 201) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('غير مصرح - تحتاج إلى تسجيل الدخول');
    } else {
      throw Exception('فشل رفع المنتج: ${response.statusCode}');
    }
  }

  Future<ProductModel> updateProduct(
      int id, {
        int? store_id,
        String? product_name,
        int? type_id,
        String? product_description,
        String? product_price,
        int? product_available,
        int? product_state,

        // صورة 1 (اختيارية في التعديل)، إن وُجدت تُستبدل القديمة
        File? product_photo_file_1,         // للموبايل
        Uint8List? product_photo_bytes_1,   // للويب

        // باقي الصور (اختياري)
        File? product_photo_file_2,
        Uint8List? product_photo_bytes_2,
        File? product_photo_file_3,
        Uint8List? product_photo_bytes_3,
        File? product_photo_file_4,
        Uint8List? product_photo_bytes_4,
      }) async {
    var uri = Uri.parse('${ApiService.baseUrl}/products/update/$id');
    var request = http.MultipartRequest('POST', uri);

    // Laravel PATCH
    request.fields['_method'] = 'PATCH';

    // هيدرز مع التوكن
    final headers = await _getMultipartHeaders();
    request.headers.addAll(headers);

    // حقول عادية
    if (store_id != null) request.fields['store_id'] = store_id.toString();
    if (product_name != null) request.fields['product_name'] = product_name;
    if (type_id != null) request.fields['type_id'] = type_id.toString();
    if (product_description != null) {
      request.fields['product_description'] = product_description;
    }
    if (product_price != null) request.fields['product_price'] = product_price;
    if (product_available != null) {
      request.fields['product_available'] = product_available.toString();
    }
    if (product_state != null) {
      request.fields['product_state'] = product_state.toString();
    }

    // ✅ الصورة 1: إن وُجدت (File أو Bytes) نرفعها؛ غير هيك ما منبعث شي -> تبقى القديمة
    if (!kIsWeb && product_photo_file_1 != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'product_photo_1',
        product_photo_file_1.path,
      ));
    } else if (kIsWeb && product_photo_bytes_1 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_1',
        product_photo_bytes_1,
        filename: 'product_1.jpg',
      ));
    }

    // الصور 2-4 (اختياري)
    if (!kIsWeb && product_photo_file_2 != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'product_photo_2',
        product_photo_file_2.path,
      ));
    } else if (kIsWeb && product_photo_bytes_2 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_2',
        product_photo_bytes_2,
        filename: 'product_2.jpg',
      ));
    }

    if (!kIsWeb && product_photo_file_3 != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'product_photo_3',
        product_photo_file_3.path,
      ));
    } else if (kIsWeb && product_photo_bytes_3 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_3',
        product_photo_bytes_3,
        filename: 'product_3.jpg',
      ));
    }

    if (!kIsWeb && product_photo_file_4 != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'product_photo_4',
        product_photo_file_4.path,
      ));
    } else if (kIsWeb && product_photo_bytes_4 != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'product_photo_4',
        product_photo_bytes_4,
        filename: 'product_4.jpg',
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('غير مصرح - تحتاج إلى تسجيل الدخول');
    } else {
      throw Exception("فشل تعديل المنتج: ${response.statusCode}, ${response.body}");
    }
  }


  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteProduct(int id) async {
    await apiService.patch('products/delete/$id', {'state': 0});
  }
}