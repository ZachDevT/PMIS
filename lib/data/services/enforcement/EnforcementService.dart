import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/features/pmis/qualification/controllers/QualificationController.dart';

class EnforcementService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch Enforcement data from the API
  /// Returns list of Enforcement records on success, throws appropriate exception on failure
  Future<List<Map<String, dynamic>>> getEnforcementData() async {
    try {
      final uri = Uri.parse('$_baseUrl/Enforcement');

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
          final List<Map<String, dynamic>> enforcementData =
              dataList.map((item) => item as Map<String, dynamic>).toList();

          return enforcementData;
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
            'Enforcement service not found. Please try again later');

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

  /// Map local JSON keys to exactly what the API expects for Enforcement
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    final Map<String, dynamic> apiData = {};

    // Inspection date
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

    // Basic fields
    apiData['inspectorName'] = data['inspectorName'];
    apiData['inspectorId'] = data['inspectorId'];

    // GPS / LatLng
    double lat = 0.0;
    double lon = 0.0;
    if (data['gps'] != null && data['gps'].toString().isNotEmpty) {
      final gpsStr = data['gps'].toString();
      final cleanGps = gpsStr
          .replaceAll('Lat:', '')
          .replaceAll('Lon:', '')
          .replaceAll('lat:', '')
          .replaceAll('lon:', '')
          .trim();
      final parts = cleanGps.split(',');
      if (parts.length == 2) {
        lat = double.tryParse(parts[0].trim()) ?? 0.0;
        lon = double.tryParse(parts[1].trim()) ?? 0.0;
      }
    } else {
      lat = data['latitude']?.toDouble() ?? 0.0;
      lon = data['longitude']?.toDouble() ?? 0.0;
    }
    apiData['latitude'] = lat;
    apiData['longitude'] = lon;

    // Region / District
    apiData['intRegion'] = data['region'] != null
        ? _getRegionGuid(data['region'].toString())
        : null;
    apiData['districtId'] = data['district'] != null
        ? _getDistrictId(data['district'].toString())
        : null;

    // Facility details
    apiData['facilityName'] = data['facilityName'];
    apiData['facilityStatus'] = _getFacilityStatus(data['facilityStatus']);
    // Map person found at facility
    final personStr =
        data['personFoundAtFacility']?.toString().toLowerCase() ?? '';
    apiData['facilityPersonType'] = personStr.contains('attendant')
        ? 2
        : personStr.contains('in-charge')
            ? 1
            : 0;
    apiData['personName'] = data['personName'];
    apiData['contact'] = data['contact'];
    apiData['qualificationId'] = data['qualificationId'] ??
        QualificationController.instance
            .idForName(data['qualifications']?.toString() ?? '');
    apiData['categoryOfpremises'] =
        _getCategoryOfPremises(data['categoryOfPremises']);

    // In enforcement, "Category of Drugs" maps to "categoryOfpremisesOther" maybe?
    // According to API, it has categoryOfpremisesOther, but no categoryOfDrugs.
    // Or we just ignore it.

    // License handling
    apiData['licenseStatus'] = _mapLicenseStatus(data['licenseStatus']);
    if (data.containsKey('licenseNo') && data['licenseNo'] != null) {
      apiData['licenseNo'] = data['licenseNo'];
    }

    // VERY IMPORTANT: The API expects licenseExpDate NOT licenseExpiryDate
    if (data.containsKey('licenseExpiryDate') &&
        data['licenseExpiryDate'] != null &&
        data['licenseExpiryDate'].toString().isNotEmpty) {
      // Extract only the date part YYYY-MM-DD to satisfy DateOnly API requirement
      apiData['licenseExpDate'] =
          data['licenseExpiryDate'].toString().split('T')[0].split(' ')[0];
    }

    // Category and enforcement action
    apiData['categoryStatus'] = _mapCategoryStatus(data['categoryStatus']);

    final actionCode = _mapEnforcementAction(data['enforcementActionTaken']);
    apiData['enfAction'] = actionCode.toString();

    apiData['comments'] = data['comments'];

    return apiData;
  }

  int _mapLicenseStatus(dynamic status) {
    // Accept numeric or string labels
    if (status is int) return status;
    if (status is String) {
      final s = status.toLowerCase();
      if (s.contains('licensed')) return 1;
      if (s.contains('un')) return 2;
      if (s.contains('not')) return 3;
    }
    return 1; // default to Licensed
  }

  int _mapEnforcementAction(dynamic action) {
    if (action is int) return action;
    if (action is String) {
      final lower = action.toLowerCase();
      // Handle multi-select comma-separated values — pick the most severe action or map first match
      if (lower.contains('warning')) return 7;
      if (lower.contains('caution')) return 6;
      if (lower.contains('no action')) return 5;
      if (lower.contains('court')) return 4;
      if (lower.contains('close')) return 3;
      if (lower.contains('arrest')) return 2;
      if (lower.contains('impound')) return 1;
    }
    return 5; // Default to No Action Taken
  }

  int _mapCategoryStatus(dynamic status) {
    if (status is int) return status;
    if (status is String) {
      switch (status) {
        case 'Medical Device':
          return 1;
        case 'Veterinary drugs':
          return 2;
        case 'Human drugs':
          return 3;
        case 'Public Healthcare products':
          return 4;
        case 'Herbal drugs':
          return 5;
        default:
          return 1;
      }
    }
    return 1;
  }

  /// Get region GUID from region name
  String _getRegionGuid(String regionName) {
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
        return 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78';
    }
  }

  /// Get district ID from district name
  int _getDistrictId(String districtName) {
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
        return 1;
    }
  }

  /// Get facility status code
  int _getFacilityStatus(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return 1;
      case 'CLOSED':
        return 0;
      default:
        return 1;
    }
  }

  /// Get category of premises code
  int _getCategoryOfPremises(String category) {
    switch (category.toUpperCase()) {
      case 'WHOLESALE PHARMACY - HUMAN':
        return 1;
      case 'WHOLESALE PHARMACY - VET':
        return 2;
      case 'RETAIL PHARMACY - HUMAN':
        return 3;
      case 'RETAIL PHARMACY - VET':
        return 4;
      case 'DRUG SHOP':
        return 5;
      case 'EXTERNAL STORES':
        return 6;
      case 'HOSPITAL':
        return 7;
      case 'HCIV':
        return 8;
      case 'HCIII':
        return 9;
      case 'CLINIC':
        return 10;
      case 'HERBAL SELLING OUTLET':
        return 11;
      case 'SHIFT MARKET':
        return 12;
      case 'PHARMACEUTICAL/MEDICAL DEVICE MANUFACTURING PREMISE':
        return 13;
      case 'OTHER':
        return 14;
      default:
        return 13; // Default to Enforcement
    }
  }

  /// Post Enforcement data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postEnforcementData(
      Map<String, dynamic> enforcementData) async {
    try {
      final uri = Uri.parse('$_baseUrl/Enforcement');
      print('🌐 DEBUG: Enforcement API URL: $uri');

      // Convert to API format
      final Map<String, dynamic> apiData = _mapToApiFormat(enforcementData);
      print(
          'Converted Enforcement API data: $apiData'); // Debug log    print('📤 DEBUG: Sending POST request to Enforcement API...');
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

      print(
          '📥 DEBUG: Enforcement API Response Status: ${response.statusCode}');
      print('📥 DEBUG: Enforcement API Response Body: ${response.body}');

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
              'message': 'Enforcement data saved successfully'
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
            'Enforcement service not found. Please try again later');

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
