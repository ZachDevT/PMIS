import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pmis/data/services/css/CssService.dart';

void main() {
  test('CssService sends qualificationOther and comments for updated API schema', () async {
    Map<String, dynamic>? requestBody;

    final service = CssService(
      client: MockClient((request) async {
        requestBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('{"success":true}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await service.postCssData({
      'inspectionDate': '2026-08-03T10:00:00.000',
      'inspectorName': 'Tester',
      'inspectorId': '1',
      'latitude': 0.0,
      'longitude': 0.0,
      'intRegion': 'region-guid',
      'districtId': 1,
      'facilityName': 'Sample Facility',
      'facilityStatus': 1,
      'facilityPersonType': 1,
      'personName': 'Person',
      'contact': '0770000000',
      'qualificationId': null,
      'qualifications': 'Other',
      'categoryOfpremises': 3,
      'other_CategoryPremise': '',
      'licenseStatus': 1,
      'licenseNo': '123',
      'licenseExpiryDate': '2026-12-31',
      'unlicensed': 0,
      'categoryStatus': 1,
      'premisesCondition': 1,
      'recordKeeping': 1,
      'classofDrugs': 1,
      'unRegisteredDrug': 0,
      'unRegDrugQty': '',
      'previouslyLicensed': '',
      'action': 'No Action',
      'comments': 'Updated API comment',
      'qualificationOther': 'Pharmacist',
    });

    expect(requestBody, isNotNull);
    expect(requestBody!['qualificationOther'], 'Pharmacist');
    expect(requestBody!['comments'], 'Updated API comment');
  });
}
