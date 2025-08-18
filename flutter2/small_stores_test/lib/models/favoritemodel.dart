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
    return Favorit(
      id: json['id'],
      user_id : json['user_id'],
      product_id  : json['product_id'],
      state : json['state'],
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
