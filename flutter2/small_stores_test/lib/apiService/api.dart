import 'package:http/http.dart' as http;
import 'api_service.dart';

final ApiService apiService = ApiService(client: http.Client());
