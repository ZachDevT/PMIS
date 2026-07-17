import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/utils/config.dart';

class CssService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch CSS data from the API
  /// Returns list of CSS records on success, throws appropriate exception on failure
  Future<List<Map<String, dynamic>>> getCssData() async {
    try {
      final uri = Uri.parse('$_baseUrl/CSS');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeoutDuration);

      return await _handleResponse(response);
    } on TimeoutException {
      throw const TimeoutException('Request timeout. Please try again.');
    } on SocketException {
      throw const NetworkException(
          'No internet connection. Please check your network.');
    } on HttpException {
      throw const NetworkException('Network error occurred. Please try again.');
    } on FormatException {
      throw const ServerException('Invalid response format from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      // Check if it's a timeout error
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('Future not completed')) {
        throw const TimeoutException('Request timeout. Please try again.');
      }
      throw NetworkException('An unexpected error occurred: ${e.toString()}');
    }
  }

// Top-level parser for compute() to run in background isolate
  List<Map<String, dynamic>> _parseJsonList(String body) {
    final List<dynamic> dataList = jsonDecode(body) as List<dynamic>;
    final List<Map<String, dynamic>> cssData =
        dataList.map((item) => item as Map<String, dynamic>).toList();
    return cssData;
  }

  /// Handle HTTP response and return parsed data
  Future<List<Map<String, dynamic>>> _handleResponse(
      http.Response response) async {
    switch (response.statusCode) {
      case 200:
        try {
          // Offload JSON parsing to background isolate to avoid UI jank
          final List<Map<String, dynamic>> cssData =
              await compute(_parseJsonList, response.body);

          // Debug: Print raw API response only when debugLogging enabled
          if (AppConfig.debugLogging) {
            print('=== CSS API Response Debug ===');
            print('Total records: ${cssData.length}');
            if (cssData.isNotEmpty) {
              print('First record keys: ${cssData.first.keys.toList()}');
              print('First record data: ${cssData.first}');
              print(
                  'Inspector Name from API: ${cssData.first['inspectorName'] ?? cssData.first['InspectorName'] ?? 'NOT FOUND'}');
              print(
                  'Inspector ID from API: ${cssData.first['inspectorId'] ?? cssData.first['InspectorId'] ?? 'NOT FOUND'}');
            }
            print('=== End CSS API Debug ===');
          }

          return cssData;
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
        throw const AuthException('Authentication required');

      case 403:
        throw const AuthException(
            'Access denied. Please contact administrator');

      case 404:
        throw const NetworkException(
            'CSS service not found. Please try again later');

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

  /// Map local JSON keys to exactly what the API expects for CSS
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    final Map<String, dynamic> apiData = Map<String, dynamic>.from(data);
    
    // Always remove ID for new records so the server generates a new one.
    // Local SQLite IDs or timestamp IDs will cause the server to reject the POST.
    apiData.remove('id');

    // Map license expiry date
    if (apiData.containsKey('licenseExpiryDate')) {
      apiData['licenseExpDate'] = apiData['licenseExpiryDate'];
      apiData.remove('licenseExpiryDate');
    }

    return apiData;
  }

  /// Post CSS data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postCssData(Map<String, dynamic> cssData) async {
    try {
      final uri = Uri.parse('$_baseUrl/CSS');

      // Map local to API format
      final Map<String, dynamic> apiData = _mapToApiFormat(cssData);
      if (AppConfig.debugLogging)
        print('Converted CSS API data: $apiData'); // Debug log (conditional)

      final response = await http
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(apiData),
          )
          .timeout(_timeoutDuration);

      return _handlePostResponse(response);
    } on TimeoutException {
      throw const TimeoutException('Request timeout. Please try again.');
    } on SocketException {
      throw const NetworkException(
          'No internet connection. Please check your network.');
    } on HttpException {
      throw const NetworkException('Network error occurred. Please try again.');
    } on FormatException {
      throw const ServerException('Invalid response format from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      // Check if it's a timeout error
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('Future not completed')) {
        throw const TimeoutException('Request timeout. Please try again.');
      }
      throw NetworkException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Handle POST response
  Map<String, dynamic> _handlePostResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          if (response.body.isEmpty) {
            return {'success': true, 'message': 'CSS data saved successfully'};
          }

          final Map<String, dynamic> data =
              jsonDecode(response.body) as Map<String, dynamic>;
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
        throw const AuthException('Authentication required');

      case 403:
        throw const AuthException(
            'Access denied. Please contact administrator');

      case 404:
        throw const NetworkException(
            'CSS service not found. Please try again later');

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
}
