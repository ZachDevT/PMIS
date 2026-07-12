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
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      inspectionDate: json['inspectionDate'] != null
          ? DateTime.parse(json['inspectionDate'])
          : DateTime.now(),
      inspectorName: json['inspectorName'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      region: json['region'] ?? '',
      district: json['district'] ?? '',
      venueLocation: json['venueLocation'] ?? json['venue'] ?? '',
      topicOfDiscussion: json['topicOfDiscussion'] ?? json['topic'] ?? '',
      numberOfParticipants: json['numberOfParticipants'] ?? json['participants'] ?? 0,
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
}

