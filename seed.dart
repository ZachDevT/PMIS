import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('http://pmis.nda.or.ug/api/SM');
  print('Seeding 5 Sensitization Meetings to $url');

  final List<Map<String, dynamic>> records = [
    {
      'inspectionDate': '2026-07-10T09:00:00',
      'inspectorName': 'admin',
      'intRegion': '87ddeda4-cef9-4e7b-ad44-34bb56081916', // CENTRAL
      'latitude': 0.3476,
      'longitude': 32.5825,
      'districtId': 1, // Kampala
      'facilityName': 'Kampala Central Market',
      'topic': 'Substandard and Falsified Medicines Awareness',
      'participants': 45,
    },
    {
      'inspectionDate': '2026-07-11T10:00:00',
      'inspectorName': 'admin',
      'intRegion': 'e9b78052-b51b-417f-b3b6-72b8ff3c4b9a', // EASTERN
      'latitude': 0.4500,
      'longitude': 33.2000,
      'districtId': 3, // Kabale
      'facilityName': 'Jinja Town Hall',
      'topic': 'Drug Abuse and Self-Medication Dangers',
      'participants': 60,
    },
    {
      'inspectionDate': '2026-07-12T11:00:00',
      'inspectorName': 'admin',
      'intRegion': 'de9b2845-56c4-4a19-8a0f-607bfd5c8689', // WESTERN
      'latitude': 0.6600,
      'longitude': 30.6700,
      'districtId': 4, // FortPortal
      'facilityName': 'Fort Portal Community Centre',
      'topic': 'Antimicrobial Resistance Sensitization',
      'participants': 35,
    },
    {
      'inspectionDate': '2026-07-13T09:30:00',
      'inspectorName': 'admin',
      'intRegion': '0b44f4f9-1423-4688-afd4-2369147e0f8f', // SOUTHERN
      'latitude': -0.3333,
      'longitude': 31.7300,
      'districtId': 2, // Masaka
      'facilityName': 'Masaka District Health Office',
      'topic': 'Rational Use of Medicines',
      'participants': 50,
    },
    {
      'inspectionDate': '2026-07-14T08:00:00',
      'inspectorName': 'admin',
      'intRegion': '87ddeda4-cef9-4e7b-ad44-34bb56081916', // NORTHERN
      'latitude': 2.7800,
      'longitude': 32.2900,
      'districtId': 4, // FortPortal
      'facilityName': 'Lira Municipal Hall',
      'topic': 'Food Safety and Standards Awareness',
      'participants': 70,
    },
  ];

  for (int i = 0; i < records.length; i++) {
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(records[i]),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        print('✅ Seeded item ${i + 1}: ID=${body['sm']['id']} - ${records[i]['facilityName']}');
      } else {
        print('❌ Failed item ${i + 1}: Status ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Exception for item ${i + 1}: $e');
    }
  }
  print('\nDone!');
}
