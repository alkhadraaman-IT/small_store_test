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
    return ProductModel(
      id: json['id'],
      store_id: json['store_id'],
      product_name: json['product_name'],
      type_id: json['type_id'],
      product_description: json['product_description'],
      product_price: json['product_price'],
      product_available: json['product_available'],
      product_state: json['product_state'],
      product_photo_1: json['product_photo_1'],
      product_photo_2: json['product_photo_2'],
      product_photo_3: json['product_photo_3'],
      product_photo_4: json['product_photo_4'],
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
