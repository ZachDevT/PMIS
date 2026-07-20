import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';

class PmsService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch PMS data from the API
  /// Returns list of PMS records on success, throws appropriate exception on failure
  Future<List<Map<String, dynamic>>> getPmsData() async {
    try {
      final uri = Uri.parse('$_baseUrl/PMS');

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
          final List<Map<String, dynamic>> pmsData =
              dataList.map((item) => item as Map<String, dynamic>).toList();

          // Debug: Print raw API response
          print('=== PMS API Response Debug ===');
          print('Total records: ${pmsData.length}');
          if (pmsData.isNotEmpty) {
            print('First record keys: ${pmsData.first.keys.toList()}');
            print('First record data: ${pmsData.first}');
            print('Inspector Name from API: ${pmsData.first['inspectorName'] ?? pmsData.first['InspectorName'] ?? 'NOT FOUND'}');
            print('Inspector ID from API: ${pmsData.first['inspectorId'] ?? pmsData.first['InspectorId'] ?? 'NOT FOUND'}');
          }
          print('=== End PMS API Debug ===');

          return pmsData;
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
            'PMS service not found. Please try again later');

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

  /// Map local JSON keys to exactly what the API expects for PMS
  Map<String, dynamic> _mapToApiFormat(Map<String, dynamic> data) {
    final Map<String, dynamic> apiData = {};

    // Combine date and time if available
    String dateTimeStr = data['inspectionDate']?.toString() ?? DateTime.now().toIso8601String();
    if (data.containsKey('inspectionTime') && data['inspectionTime'] != null) {
      try {
        final date = DateTime.parse(dateTimeStr);
        final timeStr = data['inspectionTime'].toString();
        // If it's a full ISO string, we extract time. If it's just time, we append.
        final timeParts = timeStr.split('T');
        final timeValue = timeParts.length > 1 ? timeParts[1] : timeParts[0];
        dateTimeStr = "${date.toIso8601String().split('T')[0]}T$timeValue";
      } catch (e) {
        // Fallback to inspectionDate
      }
    }
    apiData['inspectionDate'] = dateTimeStr;

    apiData['inspectorName'] = data['inspectorName'];
    // Inspector ID is not in PmsaModel, maybe we can pass empty string if missing
    apiData['inspectorId'] = data['inspectorId'] ?? '';

    // GPS / LatLng
    double lat = 0.0;
    double lon = 0.0;
    if (data['gpsLocation'] != null && data['gpsLocation'].toString().isNotEmpty) {
      final gpsStr = data['gpsLocation'].toString();
      final cleanGps = gpsStr.replaceAll(RegExp(r'[a-zA-Z:]'), '').trim();
      final parts = cleanGps.split(',');
      if (parts.length == 2) {
        lat = double.tryParse(parts[0].trim()) ?? 0.0;
        lon = double.tryParse(parts[1].trim()) ?? 0.0;
      }
    }
    apiData['latitude'] = lat;
    apiData['longitude'] = lon;

    // Region / District
    // Map string values to their UUID / int counterparts (using dummy mappings or keeping as string if API accepts name)
    // The previous implementation mapped these properly? 
    // Actually, PmsaModel stores the name. We might need to map them back to UUID/ID.
    apiData['intRegion'] = data['region'] ?? ''; 
    apiData['districtId'] = 0; // Or a mapping function
    // For now we pass as is, assuming backend might try to parse or we need mapping functions.
    // Let's implement the mapping functions we saw in EnforcementService:
    apiData['intRegion'] = _getRegionGuid(data['region']?.toString() ?? '');
    apiData['districtId'] = _getDistrictId(data['district']?.toString() ?? '');

    apiData['facilityName'] = data['facilityName'];
    apiData['facilityStatus'] = _getFacilityStatus(data['facilityStatus']?.toString() ?? '');
    apiData['facilityPersonType'] = _getPersonType(data['personFoundAtFacility']?.toString() ?? '');
    apiData['personName'] = data['name'];
    apiData['contact'] = data['contact'];
    apiData['qualifications'] = data['qualifications'];
    
    apiData['categoryOfpremises'] = _getCategoryOfPremises(data['categoryOfFacility']?.toString() ?? '');
    apiData['other_CategoryPremise'] = data['categoryOfDrugs']; 

    apiData['licenseStatus'] = _mapLicenseStatus(data['licensedStatus']?.toString() ?? '');
    apiData['licenseNo'] = data['licenseNo'] ?? '';
    if (data.containsKey('licenseExpiryDate') &&
        data['licenseExpiryDate'] != null && 
        data['licenseExpiryDate'].toString().isNotEmpty) {
      apiData['licenseExpDate'] = data['licenseExpiryDate'];
    }
    apiData['unlicensed'] = data['previouslyLicensed']; // Map to previouslyLicensed

    apiData['pmsActivity'] = _getPmsActivityCode(data['pmsaActivityCarriesOut']?.toString() ?? '');
    
    apiData['sample_ProductName'] = data['productSampledName'];
    apiData['sample_No'] = int.tryParse(data['numberOfSamplesCollected']?.toString() ?? '0') ?? 0;
    apiData['sample_Batch'] = data['batchNumberOfSample'];
    
    apiData['followup_Comment'] = data['commentOnOverallFollowUp'];
    apiData['complaint_Product'] = data['productComplaintInvestigated'];
    apiData['other_Activity'] = data['specifyActivity'];

    return apiData;
  }

  int _getFacilityStatus(String status) {
    if (status.toLowerCase() == 'closed') return 0;
    return 1;
  }

  int _getPersonType(String type) {
    if (type.toLowerCase().contains('in-charge')) return 1;
    if (type.toLowerCase().contains('attendant')) return 2;
    return 1;
  }

  int _mapLicenseStatus(String status) {
    final s = status.toLowerCase();
    if (s.contains('licensed') && !s.contains('un')) return 1;
    if (s.contains('un')) return 2;
    if (s.contains('not')) return 3;
    return 1;
  }

  int _getCategoryOfPremises(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('wholesale')) return 1;
    if (cat.contains('retail')) return 2;
    if (cat.contains('drug shop')) return 3;
    if (cat.contains('hospital')) return 5;
    if (cat.contains('hciv')) return 6;
    if (cat.contains('hciii')) return 7;
    if (cat.contains('clinic')) return 8;
    return 1;
  }

  int _getPmsActivityCode(String activity) {
    // This is a guess based on standard enum mappings, adjust as needed
    if (activity.toLowerCase().contains('sample')) return 1;
    if (activity.toLowerCase().contains('follow')) return 2;
    if (activity.toLowerCase().contains('complaint')) return 3;
    if (activity.toLowerCase().contains('other')) return 4;
    if (activity.toLowerCase().contains('none')) return 5;
    return 5; // Default to None
  }

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
      default:
        return 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78';
    }
  }

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

  /// Post PMS data to the API
  /// Returns success response on success, throws appropriate exception on failure
  Future<Map<String, dynamic>> postPmsData(Map<String, dynamic> pmsData) async {
    try {
      final uri = Uri.parse('$_baseUrl/PMS');

      // Map local to API format
      final Map<String, dynamic> apiData = _mapToApiFormat(pmsData);
      print('Converted PMS API data: $apiData'); // Debug log

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
            return {'success': true, 'message': 'PMS data saved successfully'};
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
            'PMS service not found. Please try again later');

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
