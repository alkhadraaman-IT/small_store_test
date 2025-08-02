import 'package:small_stores_test/models/classmodel.dart';

import '../models/storemodel.dart';
import 'api_service.dart';

class StoreApi {
  final ApiService apiService;

  StoreApi({required this.apiService});

  // عرض مستخدم واحد
  Future<StoreModel > getStore(int id) async {
    final data = await apiService.get('stores/view/$id');
    return StoreModel .fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<StoreModel >> getStores() async {
    final data = await apiService.get('stores/view');
    return (data as List).map((store) => StoreModel .fromJson(store)).toList();
  }


  // إضافة مستخدم جديد
  /*Future<Store> addStore(Store store) async {
    final data = await apiService.post('stores', store.toJson());
    return Store.fromJson(data);
  }
  */
  /// إضافة مستخدم جديد (النسخة المعدلة)
  Future<StoreModel > addStore({
    required int user_id  ,
    required String store_name   ,
    required String store_phone   ,
    required String store_place  ,
    required int class_id   ,
    required String store_description  ,
    int store_state = 1 ,
    required String store_photo ,
  }) async {
    final storeData = {
      'user_id': user_id,
      'store_name': store_name,
      'store_phone': store_phone,
      'store_place': store_place,
      'class_id': class_id,
      'store_description': store_description,
      'store_state': store_state,
      'store_photo': store_photo,
    };

    final data = await apiService.post('stores/add', storeData);
    return StoreModel .fromJson(data);
  }

  // تعديل مستخدم
  Future<StoreModel > updateStore(int id, StoreModel  store) async {
    final data = await apiService.put('stores/$id', store.toJson());
    return StoreModel .fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteStore(int id) async {
    await apiService.put('stores/$id/delete', {'state': 0});
  }
}