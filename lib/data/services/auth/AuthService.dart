import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';

class AuthService {
  static const _baseUrl = 'http://192.168.180.115/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Login with username and password
  /// Returns user data on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // Validate input
      if (username.trim().isEmpty) {
        throw const ValidationException('Username cannot be empty');
      }
      if (password.trim().isEmpty) {
        throw const ValidationException('Password cannot be empty');
      }

      final uri = Uri.parse('$_baseUrl/login/login').replace(
        queryParameters: {
          'Username': username.trim(),
          'Password': password.trim(),
        },
      );

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
          'No internet connection. Please check your network.');
    } on HttpException {
      throw const NetworkException('Network error occurred. Please try again.');
    } on FormatException {
      throw const ServerException('Invalid response format from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Handle HTTP response and throw appropriate exceptions
  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          final Map<String, dynamic> data =
              jsonDecode(response.body) as Map<String, dynamic>;

          // Validate response structure
          if (data.isEmpty) {
            throw const ServerException('Empty response from server');
          }

          return data;
        } catch (e) {
          if (e is FormatException) {
            throw const ServerException('Invalid JSON response from server');
          }
          rethrow;
        }

      case 400:
        final errorMessage = _extractErrorMessage(response.body);
        throw ValidationException(errorMessage);

      case 401:
        throw const AuthException('Invalid username or password');

      case 403:
        throw const AuthException(
            'Access denied. Please contact administrator');

      case 404:
        throw const NetworkException(
            'Service not found. Please try again later');

      case 408:
        throw const TimeoutException('Request timeout. Please try again');

      case 500:
        throw const ServerException(
            'Internal server error. Please try again later');

      case 502:
      case 503:
      case 504:
        throw const ServerException(
            'Service temporarily unavailable. Please try again later');

      default:
        final errorMessage = _extractErrorMessage(response.body);
        throw NetworkException(errorMessage, response.statusCode);
    }
  }

  /// Extract error message from response body
  String _extractErrorMessage(String responseBody) {
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(responseBody) as Map<String, dynamic>;
      return decoded['message'] ?? decoded['error'] ?? 'An error occurred';
    } catch (e) {
      return 'An error occurred while processing the response';
    }
  }

  /// Logout method (if needed for future implementation)
  Future<void> logout() async {
    // Implementation for logout if needed
    // This could clear local storage, invalidate tokens, etc.
  }
}
