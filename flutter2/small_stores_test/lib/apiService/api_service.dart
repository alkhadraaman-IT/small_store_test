import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  final http.Client client;
  String? _token;

  ApiService({required this.client, String? access_token}) : _token = access_token;

  // حمّل التوكن من الذاكرة (SharedPreferences)
  Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    print('Loaded Token: $_token');

  }

  // عيّن/أزل التوكن وقت الحاجة (تسجيل دخول/خروج)
  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // GET
  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    if (_token == null) await loadTokenFromStorage(); // ⬅️ تحميل تلقائي
    final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);
    final response = await client.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // POST
  Future<dynamic> post(String endpoint, dynamic body) async {
    if (_token == null) await loadTokenFromStorage(); // ⬅️ تحميل تلقائي
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await client.post(uri, headers: _headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  // PATCH
  Future<dynamic> patch(String endpoint, dynamic body) async {
    if (_token == null) await loadTokenFromStorage(); // ⬅️ تحميل تلقائي
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await client.patch(uri, headers: _headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  // DELETE
  Future<dynamic> delete(String endpoint) async {
    if (_token == null) await loadTokenFromStorage(); // ⬅️ تحميل تلقائي
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await client.delete(uri, headers: _headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    // نجاح
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null; // مثل 204 No Content
      return jsonDecode(response.body);
    }

    // فشل
    throw Exception('فشل في الطلب: ${response.statusCode}, ${response.body}');
  }

  Future<String?> getToken() async {
    if (_token == null) {
      await loadTokenFromStorage();
    }
    return _token;
  }

  Map<String, String> getHeaders() {
    return _headers;
  }
}

