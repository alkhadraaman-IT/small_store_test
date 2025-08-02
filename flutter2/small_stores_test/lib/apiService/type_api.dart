import 'api_service.dart';
import '../models/typemodel.dart';

class TypeApi {
  final ApiService apiService;

  TypeApi({required this.apiService});

  // عرض مستخدم واحد
  Future<ProductType > getType(int id) async {
    final data = await apiService.get('types/view/$id');
    return ProductType .fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<ProductType >> getTypes() async {
    final data = await apiService.get('types/view');
    return (data as List).map((type) => ProductType .fromJson(type)).toList();
  }

  // إضافة مستخدم جديد
  Future<ProductType > addType(ProductType  type) async {
    final data = await apiService.post('types', type.toJson());
    return ProductType .fromJson(data);
  }

  // تعديل مستخدم
  Future<ProductType > updateType(int id, ProductType  type) async {
    final data = await apiService.put('types/$id', type.toJson());
    return ProductType .fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteType(int id) async {
    await apiService.put('types/$id/delete', {'state': 0});
  }
}