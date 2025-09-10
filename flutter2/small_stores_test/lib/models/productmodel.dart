class ProductModel {
  final int id;
  final int store_id ;
  final String product_name;
  final int type_id ;
  final String product_description;
  final double product_price;
  int product_available;
  final int product_state;
  final String product_photo_1;
  final String? product_photo_2;
  final String? product_photo_3;
  final String? product_photo_4;

  ProductModel({
    required this.id,
    required this.store_id ,
    required this.product_name,
    required this.type_id,
    required this.product_description ,
    required this.product_price,
    required this.product_available,
    required this.product_state,
    required this.product_photo_1,
    this.product_photo_2,
    this.product_photo_3,
    this.product_photo_4,
  });

  // Factory method to convert JSON to Product object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final productData = json['product'] ?? json;

    return ProductModel(
      id: productData['id'],
      store_id: int.parse(productData['store_id'].toString()), // المشكلة هنا
      product_name: productData['product_name'],
      type_id: int.parse(productData['type_id'].toString()), // المشكلة هنا
      product_description: productData['product_description'] ,
      product_price: double.tryParse(productData['product_price'].toString()) ?? 0.0,
      product_available: productData['product_available'] ?? 1,
      product_state: productData['product_state'] ?? 1,
      product_photo_1: productData['product_photo_1'] ,
      product_photo_2: productData['product_photo_2'],
      product_photo_3: productData['product_photo_3'],
      product_photo_4: productData['product_photo_4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
  }
}
