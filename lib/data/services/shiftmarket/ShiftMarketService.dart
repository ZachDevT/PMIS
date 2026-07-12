import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';

class ShiftMarketService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch Shift Market data from the API
  /// Returns list of Shift Market records on success, throws appropriate exception on failure
  Future<List<Map<String, dynamic>>> getShiftMarketData() async {
    try {
      final uri = Uri.parse('$_baseUrl/ShiftMarket');

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
          final List<Map<String, dynamic>> shiftMarketData =
              dataList.map((item) => item as Map<String, dynamic>).toList();

          return shiftMarketData;
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
            'Shift Market service not found. Please try again later');

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

  /// Convert to API format for ShiftMarket
  Map<String, dynamic> _convertToPascalCase(Map<String, dynamic> data) {
    final Map<String, dynamic> converted = {};

    if (data['inspectionDate'] is DateTime) {
      converted['InspectionDate'] =
          (data['inspectionDate'] as DateTime).toIso8601String();
    } else {
      converted['InspectionDate'] =
          DateTime.parse(data['inspectionDate']).toIso8601String();
    }

    converted['InspectorName'] = data['inspectorName'];

    final lat = data['latitude']?.toDouble() ?? 0.0;
    final lon = data['longitude']?.toDouble() ?? 0.0;
    converted['Gps'] = data['gps'] ?? '$lat,$lon';
    converted['Latitude'] = lat;
    converted['Longitude'] = lon;

    converted['IntRegion'] =
        data['region'] != null ? _getRegionGuid(data['region']) : null;
    converted['DistrictId'] =
        data['district'] != null ? _getDistrictId(data['district']) : null;

    converted['FacilityName'] = data['facilityName'];
    converted['FacilityPersonType'] = 1;
    converted['PersonName'] = data['personName'];
    converted['Contact'] = data['contact'];
    converted['Qualifications'] = data['qualifications'];
    converted['CategoryOfpremises'] =
        _getCategoryOfPremises(data['categoryOfPremises']);

    // License handling
    converted['LicenseStatus'] = _mapLicenseStatus(data['licenseStatus']);
    if (data.containsKey('licenseNo'))
      converted['LicenseNo'] = data['licenseNo'];
    if (data.containsKey('licenseExpiryDate') &&
        (data['licenseExpiryDate'] as String).isNotEmpty) {
      converted['LicenseExpiryDate'] = data['licenseExpiryDate'];
    }

    converted['RegulatoryAction'] =
        data['regulatoryActionTaken'] ?? data['regulatoryAction'];
    converted['Consignment'] = data['consignmentsImpounded'];

    return converted;
  }

  int _mapLicenseStatus(dynamic status) {
    if (status is int) return status;
    if (status is String) {
      final s = status.toLowerCase();
      if (s.contains('licensed')) return 1;
      if (s.contains('un')) return 2;
      if (s.contains('not')) return 3;
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

  /// Get category of premises code
  int _getCategoryOfPremises(String category) {
    switch (category.toUpperCase()) {
      case 'WHOLESALE PHARMACY':
        return 1;
      case 'RETAIL PHARMACY':
        return 2;
      case 'DRUG SHOP':
        return 3;
      case 'EXTERNAL STORES':
        return 4;
      case 'HOSPITAL':
        return 5;
      case 'HCIV':
        return 6;
      case 'HCIII':
        return 7;
      case 'CLINIC':
        return 8;
      case 'HERBAL SELLING OUTLET':
        return 9;
      case 'SHIFT MARKET':
        return 10;
      case 'PHARMACEUTICAL/MEDICAL DEVICE MANUFACTURING PREMISE':
        return 11;
      case 'RTS(RADIO TALK SHOW)':
        return 12;
      case 'ENFORCEMENT':
        return 13;
      case 'OTHER':
        return 14;
      default:
        return 10; // Default to Shift Market
    }
  }

  /// Post Shift Market data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postShiftMarketData(
      Map<String, dynamic> shiftMarketData) async {
    try {
      final uri = Uri.parse('$_baseUrl/ShiftMarket');
      print('🌐 DEBUG: ShiftMarket API URL: $uri');

      // Convert camelCase to PascalCase for API
      final Map<String, dynamic> apiData =
          _convertToPascalCase(shiftMarketData);
      print('🔄 DEBUG: Converted ShiftMarket API data: $apiData');

      print('📤 DEBUG: Sending POST request to ShiftMarket API...');
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
          '📥 DEBUG: ShiftMarket API Response Status: ${response.statusCode}');
      print('📥 DEBUG: ShiftMarket API Response Body: ${response.body}');

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
              'message': 'Shift Market data saved successfully'
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
            'Shift Market service not found. Please try again later');

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
