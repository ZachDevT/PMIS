import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';

class GppService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch GPP data from the API
  /// Returns list of GPP records on success, throws appropriate exception on failure
  Future<List<Map<String, dynamic>>> getGppData() async {
    try {
      final uri = Uri.parse('$_baseUrl/gpp');

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
      if (e.toString().contains('TimeoutException') || e.toString().contains('Future not completed')) {
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
          final List<Map<String, dynamic>> gppData =
              dataList.map((item) => item as Map<String, dynamic>).toList();

          return gppData;
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
            'GPP service not found. Please try again later');

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

  /// Map local JSON keys to exactly what the API expects for GPP
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    final Map<String, dynamic> apiData = {};

    // Inspection date — ensure ISO format
    if (data['inspectionDate'] != null) {
      try {
        final dt = data['inspectionDate'] is DateTime
            ? data['inspectionDate'] as DateTime
            : DateTime.parse(data['inspectionDate'].toString());
        apiData['inspectionDate'] = dt.toIso8601String();
      } catch (_) {
        apiData['inspectionDate'] = DateTime.now().toIso8601String();
      }
    } else {
      apiData['inspectionDate'] = DateTime.now().toIso8601String();
    }

    apiData['inspectorName'] = data['inspectorName'];
    apiData['inspectorId'] = data['inspectorId'] ?? '';

    // GPS coordinates — from lat/lng fields (not 'gps' string)
    apiData['latitude'] = (data['latitude'] ?? 0).toDouble();
    apiData['longitude'] = (data['longitude'] ?? 0).toDouble();

    // Region & district
    apiData['intRegion'] = data['intRegion'];
    apiData['districtId'] = data['districtId'] ?? 0;

    // Facility
    apiData['facilityName'] = data['facilityName'];
    apiData['facilityStatus'] = data['facilityStatus'] ?? 0;
    apiData['facilityPersonType'] = data['facilityPersonType'] ?? 0;

    // Person
    apiData['personName'] = data['personName'];
    apiData['contact'] = data['contact'];

    // Qualifications: map text -> qualificationId for GPP
    final q = data['qualifications']?.toString().toLowerCase() ?? '';
    int qId = 1; // Default to Pharmacist
    if (q.contains('nurse')) qId = 2;
    else if (q.contains('dispenser')) qId = 3;
    else if (q.contains('attendant')) qId = 4;
    apiData['qualificationId'] = qId;

    // Category
    apiData['categoryOfpremises'] = data['categoryOfpremises'] ?? 0;
    apiData['other_CategoryPremise'] = data['otherCategoryPremise'] ?? '';

    // License
    apiData['licenseStatus'] = data['licenseStatus'] ?? 0;
    apiData['licenseNo'] = data['licenseNo'] ?? '';

    // IMPORTANT: API expects 'licenseExpDate' not 'licenseExpiryDate'
    final expiryDate = data['licenseExpiryDate'] ?? data['licenseExpDate'] ?? '';
    if (expiryDate.toString().isNotEmpty) {
      apiData['licenseExpDate'] = expiryDate;
    }

    apiData['unlicensed'] = data['previouslyLicensed'] ?? '';

    // GPP-specific
    apiData['categoryStatus'] = data['categoryStatus'] ?? 0;
    apiData['facilityType'] = data['facilityType'] ?? 0;
    apiData['certStatus'] = data['certStatus'] ?? 0;
    apiData['recommendedforGPP'] = data['recommendedforGPP'] ?? 0;

    return apiData;
  }

  /// Post GPP data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postGppData(Map<String, dynamic> gppData) async {
    try {
      final uri = Uri.parse('$_baseUrl/gpp');

      // Map to exact API format
      final Map<String, dynamic> apiData = _mapToApiFormat(gppData);
      print('Converted API data: $apiData'); // Debug log

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
      if (e.toString().contains('TimeoutException') || e.toString().contains('Future not completed')) {
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
            return {'success': true, 'message': 'Data saved successfully'};
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
            'GPP service not found. Please try again later');

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
