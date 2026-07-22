import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

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

  /// Map local JSON keys to exactly what the API expects for ShiftMarket
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    final Map<String, dynamic> apiData = {};

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

    apiData['inspectorName'] = data['inspectorName'];
    if (data.containsKey('inspectorId')) {
      apiData['inspectorId'] = data['inspectorId'];
    }

    final lat = data['latitude']?.toDouble() ?? 0.0;
    final lon = data['longitude']?.toDouble() ?? 0.0;
    apiData['latitude'] = lat;
    apiData['longitude'] = lon;

    apiData['intRegion'] = data['region'] != null
        ? _getRegionGuid(data['region'].toString())
        : null;
    apiData['districtId'] = data['district'] != null
        ? _getDistrictId(data['district'].toString())
        : null;

    apiData['facilityName'] = data['facilityName'];
    // Map facility status from string (OPEN/CLOSED) to int
    final statusStr =
        data['facilityStatus']?.toString().toUpperCase() ?? 'OPEN';
    apiData['facilityStatus'] = statusStr.contains('CLOSE') ? 0 : 1;
    // Map person found at facility
    final personStr =
        data['personFoundAtFacility']?.toString().toUpperCase() ?? '';
    apiData['facilityPersonType'] = personStr.contains('YES') ? 1 : 0;
    apiData['personName'] = data['personName'];
    apiData['contact'] = data['contact'];
    apiData['qualifications'] = data['qualifications'];
    apiData['categoryOfpremises'] =
        _getCategoryOfPremises(data['categoryOfPremises']?.toString() ?? '');

    // License handling
    apiData['licenseStatus'] = _mapLicenseStatus(data['licenseStatus']);
    if (data.containsKey('licenseNo') && data['licenseNo'] != null) {
      apiData['licenseNo'] = data['licenseNo'];
    }
    if (data.containsKey('licenseExpiryDate') &&
        data['licenseExpiryDate'] != null &&
        data['licenseExpiryDate'].toString().isNotEmpty) {
      apiData['licenseExpDate'] = data['licenseExpiryDate'];
    }

    // Actions
    // Shift Market Specific fields might map to other API fields:
    apiData['regulatoryAction'] = data['regulatoryActionTaken'];
    apiData['consignment'] =
        data['consignmentsImpounded'] ?? data['consignment'] ?? '';
    apiData['unlicensed'] = data['previouslyLicensed'] ?? '';

    return apiData;
  }

  int _mapLicenseStatus(dynamic status) {
    if (status is int) return status;
    if (status is String) {
      final s = status.toLowerCase();
      if (s.contains('un')) return 2;
      if (s.contains('not')) return 3;
      if (s.contains('licensed')) return 1;
    }
    return 1;
  }

  /// Get region GUID from region name
  String _getRegionGuid(String regionName) {
    return RegionDistrictConstants.getRegionGuid(regionName.toUpperCase());
  }

  /// Get district ID from district name
  int _getDistrictId(String districtName) {
    return RegionDistrictConstants.getDistrictId(districtName);
  }

  /// Get facility status code

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

      // Convert to API format
      final Map<String, dynamic> apiData = _mapToApiFormat(shiftMarketData);
      print(
          'Converted ShiftMarket API data: $apiData'); // Debug log    print('📤 DEBUG: Sending POST request to ShiftMarket API...');
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
