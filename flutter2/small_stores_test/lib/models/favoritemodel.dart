class Favorit {
  final int id;
  final int user_id ;
  final int product_id  ;
  final int state ;

  Favorit({
    required this.id,
    required this.user_id ,
    required this.product_id  ,
    required this.state ,
  });

  // Factory method to convert JSON to Product object
  factory Favorit.fromJson(Map<String, dynamic> json) {
    final favData = json['data'] ?? json;

    return Favorit(
      id: favData['id'] ,
      user_id: favData['user_id'] ,
      product_id: favData['product_id'] ,
      state: favData['state'] ?? 1, // أو 0 حسب المنطق عندك
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'product_id': product_id,
      'state': state,
    };
  }
}
