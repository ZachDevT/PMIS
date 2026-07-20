import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

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

  /// Map local JSON keys to exactly what the API expects for RTS
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    String inspectionDate = DateTime.now().toIso8601String();
    try {
      if (data['inspectionDate'] != null) {
        inspectionDate = data['inspectionDate'] is DateTime
            ? (data['inspectionDate'] as DateTime).toIso8601String()
            : DateTime.parse(data['inspectionDate'].toString())
                .toIso8601String();
      }
    } catch (e) {
      // fallback to now
    }

    // Based on the existing RTS data structure from the API
    return {
      'inspectionDate': inspectionDate,
      'inspectorName': data['inspectorName'],
      'inspectorId': data['inspectorId'] ?? '',
      'latitude': data['latitude']?.toDouble() ?? 0.0,
      'longitude': data['longitude']?.toDouble() ?? 0.0,
      'intRegion': data['region'] != null
          ? _getRegionGuid(data['region'].toString())
          : null,
      'districtId': data['district'] != null
          ? _getDistrictId(data['district'].toString())
          : null,
      // The RTS API stores the radio company in facilityName. It does not
      // expose a separate radioCompanyName property in GET responses.
      'facilityName': data['radioCompanyName'] ?? data['facilityName'],
      'venue': data['venueLocation'] ?? data['facilityName'],
      'topic': data['topicOfDiscussion'] ?? data['topic'],
      'participants': data['numberOfParticipants'] ?? 0,
    };
  }

  /// Get region GUID from region name
  String _getRegionGuid(String regionName) {
    return RegionDistrictConstants.regionGuids.entries
            .where(
                (entry) => entry.key.toLowerCase() == regionName.toLowerCase())
            .firstOrNull
            ?.value ??
        '';
  }

  /// Get district ID from district name
  int _getDistrictId(String districtName) {
    return RegionDistrictConstants.districtIds.entries
            .where((entry) =>
                entry.key.toLowerCase() == districtName.toLowerCase())
            .firstOrNull
            ?.value ??
        0;
  }

  /// Post RTS data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postRtsData(Map<String, dynamic> rtsData) async {
    try {
      final uri = Uri.parse('$_baseUrl/rts');
      print('🌐 DEBUG: API URL: $uri');

      // Convert to API format
      final Map<String, dynamic> apiData = _mapToApiFormat(rtsData);
      print('Converted RTS API data: $apiData');
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
            return {
              'success': true,
              'message': 'RadioTalkShow data saved successfully'
            };
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
