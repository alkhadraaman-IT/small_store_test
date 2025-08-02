import '../models/classmodel.dart';
import 'api_service.dart';

class ClassApi {
  final ApiService apiService;

  ClassApi({required this.apiService});

  // عرض مستخدم واحد
  Future<ClassModel> getClass(int id) async {
    final data = await apiService.get('classes/view/$id');
    return ClassModel.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<ClassModel>> getClasses() async {
    final data = await apiService.get('classes/view');
    return (data as List).map((store_class) => ClassModel.fromJson(store_class)).toList();
  }
/*
  // إضافة مستخدم جديد
  Future<ClassModel> addClass(ClassModel store_classes) async {
    final data = await apiService.post('store_classes', ClassModel.toJson());
    return ClassModel.fromJson(data);
  }

  // تعديل مستخدم
  Future<Store_classes> updateClass(int id, Store_classes store_class) async {
    final data = await apiService.put('store_classes/$id', store_class.toJson());
    return Store_classes.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteClass(int id) async {
    await apiService.put('store_classes/$id/delete', {'state': 0});
  }
  */
}