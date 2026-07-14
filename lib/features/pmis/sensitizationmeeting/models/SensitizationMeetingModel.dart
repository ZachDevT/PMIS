class SensitizationMeetingActivity {
  final String id;
  final DateTime inspectionDate;
  final String inspectorName;
  final double latitude;
  final double longitude;
  final String region;
  final String district;
  final String venueLocation;
  final String topicOfDiscussion;
  final int numberOfParticipants;

  SensitizationMeetingActivity({
    required this.id,
    required this.inspectionDate,
    required this.inspectorName,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.district,
    required this.venueLocation,
    required this.topicOfDiscussion,
    required this.numberOfParticipants,
  });

  factory SensitizationMeetingActivity.fromJson(Map<String, dynamic> json) {
    return SensitizationMeetingActivity(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      inspectionDate: json['inspectionDate'] != null
          ? DateTime.parse(json['inspectionDate'])
          : DateTime.now(),
      inspectorName: json['inspectorName'] ?? '',
      latitude: (json['latitude'] ?? json['Latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? json['Longitude'] ?? 0.0).toDouble(),
      // Support both human-readable region names (local) and GUIDs (API)
      region: json['region'] != null
          ? json['region']
          : _getRegionName(json['intRegion'] ?? json['IntRegion']),
      // Support both human-readable district names (local) and IDs (API)
      district: json['district'] != null
          ? json['district']
          : _getDistrictName(json['districtId'] ?? json['DistrictId']),
      venueLocation: json['venueLocation'] ?? json['venue'] ?? json['facilityName'] ?? '',
      topicOfDiscussion: json['topicOfDiscussion'] ?? json['topic'] ?? '',
      numberOfParticipants: (json['numberOfParticipants'] ?? json['participants'] ?? 0) is int
          ? (json['numberOfParticipants'] ?? json['participants'] ?? 0)
          : int.tryParse((json['numberOfParticipants'] ?? json['participants'] ?? 0).toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionDate': inspectionDate.toIso8601String(),
      'inspectorName': inspectorName,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'district': district,
      'venueLocation': venueLocation,
      'venue': venueLocation,
      'topicOfDiscussion': topicOfDiscussion,
      'topic': topicOfDiscussion,
      'numberOfParticipants': numberOfParticipants,
      'participants': numberOfParticipants,
    };
  }

  /// Convert region name to API GUID
  String toApiRegionGuid() => _getRegionGuid(region);

  /// Convert district name to API district ID
  int toApiDistrictId() => _getDistrictId(district);

  /// Build the API-compatible payload
  Map<String, dynamic> toApiJson() {
    return {
      'inspectionDate': inspectionDate.toIso8601String(),
      'inspectorName': inspectorName,
      'intRegion': toApiRegionGuid(),
      'latitude': latitude,
      'longitude': longitude,
      'districtId': toApiDistrictId(),
      'facilityName': venueLocation,
      'topic': topicOfDiscussion,
      'participants': numberOfParticipants,
    };
  }

  static String _getRegionName(dynamic intRegion) {
    if (intRegion == null) return '';
    switch (intRegion.toString().toLowerCase()) {
      case 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78':
        return 'Head Office';
      case '87ddeda4-cef9-4e7b-ad44-34bb56081916':
        return 'Central';
      case 'e9b78052-b51b-417f-b3b6-72b8ff3c4b9a':
        return 'Eastern';
      case '0b44f4f9-1423-4688-afd4-2369147e0f8f':
        return 'Southern';
      case 'de9b2845-56c4-4a19-8a0f-607bfd5c8689':
        return 'Western';
      default:
        return intRegion.toString();
    }
  }

  static String _getDistrictName(dynamic districtId) {
    if (districtId == null) return '';
    final id = districtId is int ? districtId : int.tryParse(districtId.toString()) ?? 0;
    switch (id) {
      case 1: return 'Kampala';
      case 2: return 'Masaka';
      case 3: return 'Kabale';
      case 4: return 'FortPortal';
      default: return districtId.toString();
    }
  }

  static String _getRegionGuid(String regionName) {
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

  static int _getDistrictId(String districtName) {
    switch (districtName.toUpperCase()) {
      case 'KAMPALA': return 1;
      case 'MASAKA': return 2;
      case 'KABALE': return 3;
      case 'FORTPORTAL': return 4;
      default: return 1;
    }
  }
}
