/// RTS (Radio Talk Show) Model for PMIS
/// Represents radio talk show activities and data structure
library;

class RtsModel {
  final String? id;
  final String inspectionDate;
  final String inspectorName;
  final double latitude;
  final double longitude;
  final String region;
  final String district;
  final String venueLocation;
  final String topicOfDiscussion;
  final int numberOfParticipants;
  final String? radioCompanyName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;

  RtsModel({
    this.id,
    required this.inspectionDate,
    required this.inspectorName,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.district,
    required this.venueLocation,
    required this.topicOfDiscussion,
    required this.numberOfParticipants,
    this.radioCompanyName,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  // Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionDate': inspectionDate,
      'inspectorName': inspectorName,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'district': district,
      'venueLocation': venueLocation,
      'topicOfDiscussion': topicOfDiscussion,
      'numberOfParticipants': numberOfParticipants,
      'radioCompanyName': radioCompanyName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  // Create from JSON
  factory RtsModel.fromJson(Map<String, dynamic> json) {
    return RtsModel(
      id: json['id']?.toString(),
      inspectionDate: json['inspectionDate'] ?? '',
      inspectorName: json['inspectorName'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      region: _getRegionName(json['intRegion']),
      district: _getDistrictName(json['districtId']),
      venueLocation: json['venue'] ?? json['facilityName'] ?? '',
      topicOfDiscussion: json['topic'] ?? '',
      numberOfParticipants: json['participants'] ?? json['numberOfParticipants'] ?? 0,
      radioCompanyName: json['radioCompanyName'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isSynced: json['isSynced'] ?? false,
    );
  }

  /// Convert region GUID to region name
  static String _getRegionName(String? regionGuid) {
    if (regionGuid == null) return '';
    switch (regionGuid) {
      case 'deaf2c98-3dbb-489f-bdea-9e5fd49eec78':
        return 'HEAD OFFICE';
      case '87ddeda4-cef9-4e7b-ad44-34bb56081916':
        return 'CENTRAL';
      case 'e9b78052-b51b-417f-b3b6-72b8ff3c4b9a':
        return 'EASTERN';
      case '0b44f4f9-1423-4688-afd4-2369147e0f8f':
        return 'SOUTHERN';
      case 'de9b2845-56c4-4a19-8a0f-607bfd5c8689':
        return 'WESTERN';
      default:
        return 'HEAD OFFICE';
    }
  }

  /// Convert district ID to district name
  static String _getDistrictName(int? districtId) {
    if (districtId == null) return '';
    switch (districtId) {
      case 1:
        return 'KAMPALA';
      case 2:
        return 'MASAKA';
      case 3:
        return 'KABALE';
      case 4:
        return 'FORTPORTAL';
      default:
        return 'KAMPALA';
    }
  }

  // Create a copy with updated fields
  RtsModel copyWith({
    String? id,
    String? inspectionDate,
    String? inspectorName,
    double? latitude,
    double? longitude,
    String? region,
    String? district,
    String? venueLocation,
    String? topicOfDiscussion,
    int? numberOfParticipants,
    String? radioCompanyName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return RtsModel(
      id: id ?? this.id,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      inspectorName: inspectorName ?? this.inspectorName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      district: district ?? this.district,
      venueLocation: venueLocation ?? this.venueLocation,
      topicOfDiscussion: topicOfDiscussion ?? this.topicOfDiscussion,
      numberOfParticipants: numberOfParticipants ?? this.numberOfParticipants,
      radioCompanyName: radioCompanyName ?? this.radioCompanyName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
