/// RTS (Radio Talk Show) Model for PMIS
/// Represents radio talk show activities and data structure
library;

import 'package:pmis/utils/constants/regions_districts.dart';

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
      region: json['region']?.toString() ?? _getRegionName(json['intRegion']),
      district:
          json['district']?.toString() ?? _getDistrictName(json['districtId']),
      venueLocation:
          json['venueLocation'] ?? json['venue'] ?? json['facilityName'] ?? '',
      topicOfDiscussion: json['topicOfDiscussion'] ?? json['topic'] ?? '',
      numberOfParticipants:
          json['participants'] ?? json['numberOfParticipants'] ?? 0,
      radioCompanyName: json['radioCompanyName'] ??
          json['RadioCompanyName'] ??
          json['radio_company_name'] ??
          json['facilityName'] ??
          json['FacilityName'],
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
    return RegionDistrictConstants.regionGuids.entries
            .where((entry) => entry.value == regionGuid)
            .firstOrNull
            ?.key ??
        '';
  }

  /// Convert district ID to district name
  static String _getDistrictName(int? districtId) {
    if (districtId == null) return '';
    return RegionDistrictConstants.districtIds.entries
            .where((entry) => entry.value == districtId)
            .firstOrNull
            ?.key ??
        '';
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
