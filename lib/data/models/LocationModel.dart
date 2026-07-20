class RegionModel {
  final String intRegion;
  final String regionCode;
  final String regionName;

  RegionModel({
    required this.intRegion,
    required this.regionCode,
    required this.regionName,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      intRegion: json['intRegion'] ?? '',
      regionCode: json['regionCode'] ?? '',
      regionName: json['regionName'] ?? '',
    );
  }
}

class DistrictModel {
  final int id;
  final String name;
  final String regionId;

  DistrictModel({
    required this.id,
    required this.name,
    required this.regionId,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      regionId: json['regionId'] ?? '',
    );
  }
}
