import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pmis/utils/exceptions/api_exceptions.dart';
import 'package:pmis/data/models/LocationModel.dart';

class LocationService {
  static const _baseUrl = 'http://pmis.nda.or.ug/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  Future<List<RegionModel>> getRegions() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Region'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RegionModel.fromJson(json)).toList();
      } else {
        throw const ServerException('Failed to load regions');
      }
    } on TimeoutException {
      throw const TimeoutException('Request timeout. Please try again.');
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException('An error occurred: ${e.toString()}');
    }
  }

  Future<List<DistrictModel>> getDistricts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/District'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DistrictModel.fromJson(json)).toList();
      } else {
        throw const ServerException('Failed to load districts');
      }
    } on TimeoutException {
      throw const TimeoutException('Request timeout. Please try again.');
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException('An error occurred: ${e.toString()}');
    }
  }
}
