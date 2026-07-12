import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';

class SensitizationMeetingService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  /// Fetch Sensitization Meeting data from the API
  Future<List<Map<String, dynamic>>> getSensitizationMeetingData() async {
    try {
      final uri = Uri.parse('$_baseUrl/SensitizationMeeting');

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

          final List<Map<String, dynamic>> meetingData =
              dataList.map((item) => item as Map<String, dynamic>).toList();

          return meetingData;
        } catch (e) {
          throw ServerException('Failed to parse server response: $e');
        }
      case 401:
        throw const AuthException('Unauthorized. Please login again.');
      case 403:
        throw const AuthException('Access forbidden.');
      case 404:
        return []; // Return empty list if no data found
      case 500:
        throw const ServerException('Server error. Please try again later.');
      default:
        throw ServerException(
            'Server returned error: ${response.statusCode} - ${response.body}');
    }
  }

  /// Post Sensitization Meeting data to the API
  Future<void> postSensitizationMeetingData(
      Map<String, dynamic> meetingData) async {
    try {
      final uri = Uri.parse('$_baseUrl/SensitizationMeeting');

      final response = await http
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(meetingData),
          )
          .timeout(_timeoutDuration);

      _handlePostResponse(response);
    } on TimeoutException {
      throw const TimeoutException('Request timeout. Please try again.');
    } on SocketException {
      throw const NetworkException(
          'No internet connection. Please check your network.');
    } on HttpException {
      throw const NetworkException('Network error occurred. Please try again.');
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
  void _handlePostResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return; // Success
      case 400:
        throw const ValidationException('Invalid data format.');
      case 401:
        throw const AuthException('Unauthorized. Please login again.');
      case 403:
        throw const AuthException('Access forbidden.');
      case 404:
        // API endpoint not found/not implemented - throw exception so data can be saved locally
        throw const ServerException('API endpoint not found. Data will be saved locally for sync.');
      case 500:
        throw const ServerException('Server error. Please try again later.');
      default:
        throw ServerException(
            'Server returned error: ${response.statusCode} - ${response.body}');
    }
  }
}
