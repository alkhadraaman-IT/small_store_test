class StoreModel  {
  final int id;
  final int user_id;
  final String store_name;
  final String store_phone;
  final String store_place;
  final int class_id;
  final String store_description ;
  final int store_state;
  final String store_photo;

  StoreModel ({
    required this.id,
    required this.user_id,
    required this.store_name,
    required this.store_phone,
    required this.store_place,
    required this.class_id,
    required this.store_description,
    required this.store_state,
    required this.store_photo,
  });

  // Factory method to convert JSON to Product object
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final storeData = json['data'] ?? json;

    return StoreModel(
      id: int.tryParse(storeData['id'].toString()) ?? 0,
      user_id: int.tryParse(storeData['user_id'].toString()) ?? 0,
      store_name: storeData['store_name'] ?? '',
      store_phone: storeData['store_phone']?.toString() ?? '',
      store_place: storeData['store_place'] ?? '',
      class_id: int.tryParse(storeData['class_id'].toString()) ?? 0,
      store_description: storeData['store_description'] ?? '',
      store_state: int.tryParse(storeData['store_state'].toString()) ?? 0,
      store_photo: storeData['store_photo']?.toString() ?? '',
    );
  }




  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'store_name': store_name,
      'store_phone': store_phone,
      'store_place': store_place,
      'class_id': class_id,
      'store_description': store_description,
      'store_state': store_state,
      'store_photo': store_photo,
    };
  }
}
