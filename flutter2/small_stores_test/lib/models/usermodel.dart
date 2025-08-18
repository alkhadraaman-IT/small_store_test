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
      id: json['id'],
      name: json['name'],
      phone: json['phone'].toString(),
      email: json['email'],
      password: json['password']?? '',
      profile_photo: json['profile_photo']?.toString() ?? image_user_path, // تأكد أن image_user_path متغير نصي
      type: json['type'] is int ? json['type'] : int.tryParse(json['type'].toString()) ?? 1,
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 1,
    );
  }
  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_photo': profile_photo,
      'type': type,
      'status': status,
    };

    if (password != null && password!.trim().isNotEmpty) {
      data['password'] = password;
    }

    return data;
  }

}
