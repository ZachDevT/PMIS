import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/Login/login').replace(
      queryParameters: {
        'Username': username,
        'Password': password,
      },
    );

    // Note: empty body, but must be a POST per Swagger
    final response = await http.post(uri, headers: {
      'Accept': 'application/json',
    });

    // throw on network-level errors
    if (response.statusCode != 200) {
      final decoded = jsonDecode(response.body);
      final msg = decoded['message'] ?? response.reasonPhrase;
      throw Exception(msg);
    }

    // decode JSON to Map
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
