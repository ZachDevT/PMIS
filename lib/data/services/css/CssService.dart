import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/utils/config.dart';
import 'package:pmis/features/pmis/qualification/controllers/QualificationController.dart';

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
      // Try common error message fields
      final msg = decoded['message'] ?? decoded['error'] ?? decoded['title'];
      if (msg != null) return msg.toString();
      // If there are validation errors, stringify them
      if (decoded['errors'] != null) {
        return 'Validation error: ${decoded['errors'].toString()}';
      }
      return 'An error occurred';
    } catch (e) {
      print('CSS raw error body: $responseBody');
      return 'An error occurred';
    }
  }

  /// Map local JSON keys to exactly what the API expects for CSS
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    final Map<String, dynamic> apiData = {};

    // Ensure inspectionDate is ISO8601
    if (data['inspectionDate'] != null) {
      if (data['inspectionDate'] is DateTime) {
        apiData['inspectionDate'] =
            (data['inspectionDate'] as DateTime).toIso8601String();
      } else {
        try {
          apiData['inspectionDate'] =
              DateTime.parse(data['inspectionDate'].toString())
                  .toIso8601String();
        } catch (e) {
          apiData['inspectionDate'] = DateTime.now().toIso8601String();
        }
      }
    }

    // Direct string maps
    apiData['inspectorName'] = data['inspectorName'];
    apiData['inspectorId'] = data['inspectorId'] ?? '';

    // Float coordinates
    apiData['latitude'] = data['latitude']?.toDouble() ?? 0.0;
    apiData['longitude'] = data['longitude']?.toDouble() ?? 0.0;

    // IDs and Integers
    apiData['intRegion'] = data['intRegion'];
    apiData['districtId'] = data['districtId'];
    // Always send the numeric API contract. This also repairs legacy offline
    // rows that stored "Closed", null, or an unsupported/unknown value.
    apiData['facilityStatus'] =
        _normalizeFacilityStatus(data['facilityStatus']);
    apiData['facilityPersonType'] = data['facilityPersonType'];

    // Text fields
    apiData['facilityName'] = data['facilityName'];
    apiData['personName'] = data['personName'];
    apiData['contact'] = data['contact'];
    apiData['qualificationId'] = data['qualificationId'] ??
        QualificationController.instance
            .idForName(data['qualifications']?.toString() ?? '');
    apiData['qualificationOther'] = data['qualificationOther'] ??
        (data['qualifications']?.toString().trim().toLowerCase() == 'other'
            ? data['qualifications']?.toString().trim() ?? ''
            : '');

    // Category & License
    apiData['categoryOfpremises'] = data['categoryOfpremises'];
    apiData['other_CategoryPremise'] = data['other_CategoryPremise'];
    apiData['licenseStatus'] = data['licenseStatus'];
    apiData['licenseNo'] = data['licenseNo'];

    // IMPORTANT: API expects 'licenseExpDate' in DateOnly format YYYY-MM-DD
    final expiryDate =
        data['licenseExpiryDate'] ?? data['licenseExpDate'] ?? '';
    if (expiryDate.toString().isNotEmpty) {
      apiData['licenseExpDate'] =
          expiryDate.toString().split('T')[0].split(' ')[0];
    }

    apiData['unlicensed'] = data['unlicensed'];

    // CSS specifics
    apiData['categoryStatus'] = data['categoryStatus'];
    apiData['premisesCondition'] = data['premisesCondition'];
    apiData['recordKeeping'] = data['recordKeeping'];
    apiData['classofDrugs'] = data['classofDrugs'];
    apiData['unRegisteredDrug'] = data['unRegisteredDrug'];
    apiData['unRegDrugQty'] = data['unRegDrugQty']?.toString() ?? '';
    apiData['action'] = _mapAction(data['action']?.toString());
    apiData['comments'] = data['comments'] ?? data['comment'] ?? '';

    // Notice we DO NOT include `previouslyLicensed`, `licenseExpiryDate`, or `id`.

    return apiData;
  }

  int _normalizeFacilityStatus(dynamic status) {
    if (status is num) return status.toInt() == 1 ? 1 : 0;
    final value = status?.toString().trim().toLowerCase();
    return value == '1' || value == 'open' ? 1 : 0;
  }

  /// Map CSS Action from string to integer for the backend API
  int? _mapAction(String? actionStr) {
    if (actionStr == null || actionStr.isEmpty) return null;

    final lower = actionStr.toLowerCase();
    if (lower.contains('closed')) return 1;
    if (lower.contains('abandoned')) return 2;
    if (lower.contains('impounded')) return 3;
    if (lower.contains('suspect'))
      return 4; // covers 'suspect arrested' and typo 'aarrested'
    if (lower.contains('no action')) return 5;

    return null;
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
