import '../models/favoritemodel.dart';
import 'api_service.dart';

class FavoritApi {
  final ApiService apiService;

  FavoritApi({required this.apiService});

  // عرض مستخدم واحد
  Future<Favorit> getFavorit(int id) async {
    final data = await apiService.get('favorite/view/$id');
    return Favorit.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<Favorit>> getFavorits(int id) async {
    final response = await apiService.get('favorite/view/user/$id');

    if (response['success']) {
      if (response['data'] is List) {
        return (response['data'] as List).map((f) => Favorit.fromJson(f)).toList();
      } else {
        // إذا كانت data ليست List، نعيد list فارغة
        return [];
      }
    } else {
      throw Exception('Failed to load favorites: ${response['message']}');
    }
  }

  Future<Favorit> addFavorit({
    required int user_id,
    required int product_id,
  }) async {
    try {
      final favoritData = {
        'user_id': user_id,
        'product_id': product_id,
      };

      print('Sending data to server: $favoritData');

      final response = await apiService.post('favorite/add', favoritData);

      print('Server response: $response');

      if (response is Map) {
        final responseData = Map<String, dynamic>.from(response);

        if (responseData.containsKey('success')) {
          if (responseData['success'] == true) {
            return Favorit.fromJson(responseData['data']);
          } else {
            // نرمي استثناءً يحتوي على رسالة الخطأ
            throw Exception(responseData['message'] ?? 'Failed to add favorite');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

/*
راكز2
  Future<Favorit> addFavorit({
    required int user_id,
    required int product_id,
  }) async {
    try {
      final favoritData = {
        'user_id': user_id,
        'product_id': product_id,
      };

      print('Sending data to server: $favoritData'); // طباعة البيانات المرسلة

      final response = await apiService.post('favorite/add', favoritData);

      print('Server response: $response'); // طباعة الاستجابة من الخادم

      if (response is Map) {
        final responseData = Map<String, dynamic>.from(response);

        if (responseData.containsKey('success') && responseData['success'] == true) {
          return Favorit.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to add favorite');
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error adding favorite: $e'); // طباعة الخطأ إذا حدث
      rethrow;
    }
  }
*/
  // إضافة مستخدم جديد
  /*Future<Favorit> addFavorit(Favorit favorit) async {
    final data = await apiService.post('favorite/add', favorit.toJson());
    return Favorit.fromJson(data);
  }*/


  // تعديل مستخدم
  Future<Favorit> updateFavorit(int id, Favorit favorit) async {
    final data = await apiService.patch('favorite/update/$id', favorit.toJson());
    return Favorit.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteFavorit(int id) async {
    await apiService.patch('favorite/delete/$id', {'state': 0});
  }
//عدد المعجبين
  Future<int> getProductLikesCount(int productId) async {
    try {
      final response = await apiService.get('favorite/count/$productId');

      if (response['success'] == true) {
        return response['likes_count'] as int;
      } else {
        throw Exception(response['message'] ?? 'Failed to get likes count');
      }
    } catch (e) {
      print('Error getting product likes count: $e');
      return 0; // قيمة افتراضية في حالة الخطأ
    }
  }

  Future<List<Favorit>> getFavoritsAll(int id) async {
    final response = await apiService.get('favorite/view/All/user/$id');

    if (response['success']) {
      if (response['data'] is List) {
        return (response['data'] as List).map((f) => Favorit.fromJson(f)).toList();
      } else {
        // إذا كانت data ليست List، نعيد list فارغة
        return [];
      }
    } else {
      throw Exception('Failed to load favorites: ${response['message']}');
    }
  }

}