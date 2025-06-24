import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static String? _token;
  static const _baseUrl = 'http://localhost:8080';

  static Future<void> login() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': 'admin',
        'password': 'password',
      }),
    );
    if (response.statusCode == 200) {
      _token = json.decode(response.body)['token'];
    } else {
      throw Exception('ログイン失敗');
    }
  }

  static Future<http.Response> get(String path) async {
    if (_token == null) {
      await login();
    }
    var response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 401) {
      await login();
      response = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: {'Authorization': 'Bearer $_token'},
      );
    }
    return response;
  }
}
