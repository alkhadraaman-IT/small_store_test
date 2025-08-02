import '../models/usermodel.dart';
import 'api_service.dart';

class UserApi {
  final ApiService apiService;

  UserApi({required this.apiService});

  // عرض مستخدم واحد
  Future<User> getUser(int id) async {
    final data = await apiService.get('users/view/$id');
    return User.fromJson(data);
  }

  // عرض جميع المستخدمين
  Future<List<User>> getUsers() async {
    final data = await apiService.get('users/view');
    return (data as List).map((user) => User.fromJson(user)).toList();
  }
/*
  // إضافة مستخدم جديد
  Future<User> addUser(User user) async {
    final data = await apiService.post('users', user.toJson());
    return User.fromJson(data);
  }
*/
  /// إضافة مستخدم جديد (النسخة المعدلة)
  Future<User> addUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    bool type = true,
    bool status = true,
    String? profilePhoto,
  }) async {
    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'type': type,
      'status': status,
      if (profilePhoto != null) 'profile_photo': profilePhoto,
    };

    final data = await apiService.post('users/add', userData); // تأكد من أن المسار `/users/add` موجود في Laravel
    return User.fromJson(data);
  }

  // تعديل مستخدم
  Future<User> updateUser(int id, User user) async {
    final data = await apiService.put('users/$id', user.toJson());
    return User.fromJson(data);
  }

  // حذف مستخدم (تعديل الحقل state)
  Future<void> deleteUser(int id) async {
    await apiService.put('users/$id/delete', {'state': 0});
  }
}