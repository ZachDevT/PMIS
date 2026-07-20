import 'package:flutter_test/flutter_test.dart';
import 'package:pmis/features/pmis/rts/models/RtsModel.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

void main() {
  test('reads radio company from the RTS API facilityName field', () {
    final activity = RtsModel.fromJson({
      'id': 47,
      'inspectionDate': '2026-07-20T19:13:00',
      'inspectorName': 'admin',
      'latitude': 0.31,
      'longitude': 32.58,
      'intRegion': 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78',
      'districtId': 3,
      'facilityName': 'Voice of Kabale FM',
      'venue': 'Kabale Town',
      'topic': 'Health',
      'participants': 30,
    });

    expect(activity.radioCompanyName, 'Voice of Kabale FM');
    expect(activity.venueLocation, 'Kabale Town');
  });

  setUp(() {
    RegionDistrictConstants.regionGuids = {
      'CENTRAL': 'central-guid',
    };
    RegionDistrictConstants.districtIds = {
      'Kampala': 1,
    };
  });

  test('parses an offline RTS record without losing local fields', () {
    final record = RtsModel.fromJson({
      'id': null,
      'inspectionDate': '2026-07-20 18:00:00',
      'inspectorName': 'Inspector',
      'latitude': 0.3,
      'longitude': 32.5,
      'region': 'CENTRAL',
      'district': 'Kampala',
      'venueLocation': 'Studio',
      'topicOfDiscussion': 'Safety',
      'numberOfParticipants': 12,
      'isSynced': false,
    });

    expect(record.region, 'CENTRAL');
    expect(record.district, 'Kampala');
    expect(record.venueLocation, 'Studio');
    expect(record.topicOfDiscussion, 'Safety');
    expect(record.numberOfParticipants, 12);
    expect(record.isSynced, isFalse);
  });

  test('parses an RTS API record using API-backed location mappings', () {
    final record = RtsModel.fromJson({
      'id': 45,
      'inspectionDate': '2026-07-20T15:51:00',
      'inspectorName': 'Inspector',
      'intRegion': 'central-guid',
      'districtId': 1,
      'venue': 'Studio',
      'topic': 'Safety',
      'participants': 12,
      'isSynced': true,
    });

    expect(record.region, 'CENTRAL');
    expect(record.district, 'Kampala');
    expect(record.venueLocation, 'Studio');
    expect(record.topicOfDiscussion, 'Safety');
    expect(record.numberOfParticipants, 12);
    expect(record.isSynced, isTrue);
  });
}
