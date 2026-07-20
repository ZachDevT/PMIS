import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pmis/data/models/QualificationModel.dart';

class QualificationService {
  static const _url = 'http://pmis.nda.or.ug/api/Qualification';

  Future<List<QualificationModel>> getQualifications() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: const {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw Exception('Failed to load qualifications (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) =>
            QualificationModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
