import '../variables.dart';

class User {
  final int id;
  final String name ;
  final String phone   ;
  final String email  ;
  final String password ;
  final String? profile_photo ;
  final int type ;
  final int status ;

  User({
    required this.id,
    required this.name ,
    required this.phone   ,
    required this.email   ,
    required this.password  ,
    this.profile_photo  ,
    required this.type  ,
    required this.status ,
  });

  // Factory method to convert JSON to Product object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?? 0,
      name: json['name'] ?? '',
      phone: json['phone'].toString()?? '',
      email: json['email']?? '',
      password: json['password']?? '',
      profile_photo: json['profile_photo']?? image_user,
      type: json['type']?? 1,
      status: json['status']?? 1,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'profile_photo': profile_photo,
      'type': type,
      'status': status,
    };
  }
}
