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
      // تأكد أن data هي List وليس Map
      if (response['data'] is List) {
        return (response['data'] as List).map((f) => Favorit.fromJson(f)).toList();
      } else {
        // إذا كانت data ليست List، أنشئ List منها
        return [Favorit.fromJson(response['data'])];
      }
    } else {
      throw Exception('Failed to load favorites: ${response['message']}');
    }
  }

  // إضافة مستخدم جديد
  Future<Favorit> addFavorit(Favorit favorit) async {
    final data = await apiService.post('favorite/add', favorit.toJson());
    return Favorit.fromJson(data);
  }

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
}