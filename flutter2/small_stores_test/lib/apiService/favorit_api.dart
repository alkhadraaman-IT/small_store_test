import '../models/favoritemodel.dart';
import 'api_service.dart';

class FavoritApi {
  final ApiService apiService;

  FavoritApi({required this.apiService});

  // عرض مستخدم واحد
  Future<Favorit> getFavorit(int id) async {
    final data = await apiService.get('favorits/$id');
    return Favorit.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<Favorit>> getFavorits() async {
    final data = await apiService.get('favorits');
    return (data as List).map((favorit) => Favorit.fromJson(favorit)).toList();
  }

  // إضافة مستخدم جديد
  Future<Favorit> addFavorit(Favorit favorit) async {
    final data = await apiService.post('favorits', favorit.toJson());
    return Favorit.fromJson(data);
  }

  // تعديل مستخدم
  Future<Favorit> updateFavorit(int id, Favorit favorit) async {
    final data = await apiService.put('favorits/$id', favorit.toJson());
    return Favorit.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteFavorit(int id) async {
    await apiService.put('favorits/$id/delete', {'state': 0});
  }
}