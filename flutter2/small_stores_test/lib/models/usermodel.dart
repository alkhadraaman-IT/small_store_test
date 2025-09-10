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
    final userData = json.containsKey('user') ? json['user'] : json;
    // ناخد مفتاح user
    return User(
      id: userData['id'],
      name: userData['name'],
      phone: userData['phone'].toString(),
      email: userData['email'],
      password: '', // لأن السيرفر لا يرجع كلمة المرور
      profile_photo: userData['profile_photo']?.toString() ?? image_user_path,
      type: userData['type'] is int ? userData['type'] : int.tryParse(userData['type'].toString()) ?? 1,
      status: userData['status'] is int ? userData['status'] : int.tryParse(userData['status'].toString()) ?? 1,
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
