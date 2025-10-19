import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';

class RtsService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch RTS data from the API
  /// Returns list of RTS records on success, throws appropriate exception on failure
  Future<List<Map<String, dynamic>>> getRtsData() async {
    try {
      final uri = Uri.parse('$_baseUrl/rts');

      final response = await http.get(
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

  /// Handle HTTP response and return parsed data
  List<Map<String, dynamic>> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          final List<dynamic> dataList =
              jsonDecode(response.body) as List<dynamic>;

          // Convert to List<Map<String, dynamic>>
          final List<Map<String, dynamic>> rtsData =
              dataList.map((item) => item as Map<String, dynamic>).toList();

          return rtsData;
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
            'RadioTalkShow service not found. Please try again later');

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

  /// Convert to API format for RTS
  Map<String, dynamic> _convertToPascalCase(Map<String, dynamic> data) {
    // Based on the existing RTS data structure from the API
    return {
      'inspectionDate': data['inspectionDate'] is DateTime 
          ? (data['inspectionDate'] as DateTime).toIso8601String()
          : DateTime.parse(data['inspectionDate']).toIso8601String(),
      'inspectorName': data['inspectorName'],
      'latitude': data['latitude']?.toDouble() ?? 0.0,
      'longitude': data['longitude']?.toDouble() ?? 0.0,
      'intRegion': data['region'] != null ? _getRegionGuid(data['region']) : null,
      'districtId': data['district'] != null ? _getDistrictId(data['district']) : null,
      'facilityName': data['venueLocation'],
      'topic': data['topicOfDiscussion'],
    };
  }

  /// Get region GUID from region name
  String _getRegionGuid(String regionName) {
    // Map region names to GUIDs (these should match the API)
    switch (regionName.toUpperCase()) {
      case 'HEAD OFFICE':
        return 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78';
      case 'CENTRAL':
        return '87ddeda4-cef9-4e7b-ad44-34bb56081916';
      case 'EASTERN':
        return 'e9b78052-b51b-417f-b3b6-72b8ff3c4b9a';
      case 'SOUTHERN':
        return '0b44f4f9-1423-4688-afd4-2369147e0f8f';
      case 'WESTERN':
        return 'de9b2845-56c4-4a19-8a0f-607bfd5c8689';
      case 'NORTHERN':
        return '87ddeda4-cef9-4e7b-ad44-34bb56081916';
      default:
        return 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78'; // Default to Head Office
    }
  }

  /// Get district ID from district name
  int _getDistrictId(String districtName) {
    // Map district names to IDs (these should match the API)
    switch (districtName.toUpperCase()) {
      case 'KAMPALA':
        return 1;
      case 'MASAKA':
        return 2;
      case 'KABALE':
        return 3;
      case 'FORTPORTAL':
        return 4;
      default:
        return 1; // Default to Kampala
    }
  }

  /// Post RTS data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postRtsData(Map<String, dynamic> rtsData) async {
    try {
      final uri = Uri.parse('$_baseUrl/rts');
      print('🌐 DEBUG: API URL: $uri');

      // Convert camelCase to PascalCase for API
      final Map<String, dynamic> apiData = _convertToPascalCase(rtsData);
      print('🔄 DEBUG: Converted RadioTalkShow API data: $apiData');

      print('📤 DEBUG: Sending POST request to API...');
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

      print('📥 DEBUG: API Response Status: ${response.statusCode}');
      print('📥 DEBUG: API Response Body: ${response.body}');
      print('📥 DEBUG: API Response Headers: ${response.headers}');

      return _handlePostResponse(response);
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

  /// Handle POST response
  Map<String, dynamic> _handlePostResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          if (response.body.isEmpty) {
            return {'success': true, 'message': 'RadioTalkShow data saved successfully'};
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
            'RadioTalkShow service not found. Please try again later');

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
