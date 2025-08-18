import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  final http.Client client;

  ApiService({required this.client});

  // Helper method for GET requests
  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams),
      headers: {'Content-Type': 'application/json'},
    );

    return _handleResponse(response);
  }

  // Helper method for POST requests
  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Helper method for patch requests
  Future<dynamic> patch(String endpoint, dynamic body) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Helper method for DELETE requests
  Future<dynamic> delete(String endpoint) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}