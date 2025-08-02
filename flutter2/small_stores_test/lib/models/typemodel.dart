class ProductType  {
  final int id;
  final int class_id  ;
  final String type_name;

  ProductType ({
    required this.id,
    required this.class_id  ,
    required this.type_name,
  });

  // Factory method to convert JSON to Product object
  factory ProductType .fromJson(Map<String, dynamic> json) {
    return ProductType (
      id: json['id'],
      class_id : json['class_id'],
      type_name: json['type_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': class_id,
      'type_name': type_name,
    };
  }
}
