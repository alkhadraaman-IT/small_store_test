import '../models/productmodel.dart';
import 'api_service.dart';

class ProductApi {
  final ApiService apiService;

  ProductApi({required this.apiService});

  // عرض مستخدم واحد
  Future<ProductModel> getProduct(int id) async {
    final data = await apiService.get('products/view/$id');
    return ProductModel.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<ProductModel>> getProducts() async {
    final data = await apiService.get('products');
    return (data as List).map((product) => ProductModel.fromJson(product)).toList();
  }

  /*// إضافة مستخدم جديد
  Future<Product> addProduct(Product product) async {
    final data = await apiService.post('products', product.toJson());
    return Product.fromJson(data);
  }*/
  /// إضافة مستخدم جديد (النسخة المعدلة)
  Future<ProductModel> addProduct({
    required int store_id,
    required String product_name,
    required int type_id,
    required String product_description,
    required String product_price,
    int product_available= 1,
    int product_state= 1,
    required String product_photo_1,
    String? product_photo_2,
    String? product_photo_3,
    String? product_photo_4,
  }) async {
    final productData = {
      'store_id': store_id,
      'product_name': product_name,
      'type_id': type_id,
      'product_description': product_description,
      'product_price': product_price,
      'product_available': product_available,
      'product_state': product_state,
      'product_photo_1': product_photo_1,
      'product_photo_2': product_photo_2,
      'product_photo_3': product_photo_3,
      'product_photo_4': product_photo_4,
    };
    final data = await apiService.post('products/add', productData);
    return ProductModel.fromJson(data);
  }

  // تعديل مستخدم
  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    final data = await apiService.put('poducts/$id', product.toJson());
    return ProductModel.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteProduct(int id) async {
    await apiService.put('products/$id/delete', {'state': 0});
  }
}