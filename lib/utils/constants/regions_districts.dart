/// Dynamic constants for regions and districts across all PMIS modules
/// This ensures consistency and maintainability across the application
library;

class RegionDistrictConstants {
  // Region constants
  static List<String> regions = [
    "Head Office",
    "CENTRAL",
    "EASTERN",
    "SOUTHERN",
    "WESTERN",
    "NORTHERN"
  ];

  // All districts
  static List<String> allDistricts = [
    "Kampala",
    "Masaka",
    "Kabale",
    "Fortportal",
  ];

  // Legacy - kept for backward compatibility
  static List<String> get districts => allDistricts;

  // District-to-Region mapping
  static Map<String, String> districtToRegion = {
    "Kampala": "CENTRAL",
    "Masaka": "CENTRAL",
    "Kabale": "WESTERN",
    "Fortportal": "WESTERN",
  };

  // Region GUID mapping for API integration
  static Map<String, String> regionGuids = {
    "Head Office": "0b44cbbf-92aa-4389-b3ca-23c1976619b5",
    "CENTRAL": "87ddf86e-44bc-47e9-814a-5ecfc5dfe8ab",
    "EASTERN": "de9b4a3f-7883-4615-a5c5-33104d75c321",
    "SOUTHERN": "e9b92645-2d63-4d93-bf93-0faef323f5fa",
    "WESTERN": "deaf2c98-3dbb-489f-bdea-9e5fd49eec78",
    "NORTHERN": "57a2afce-98b8-48b2-984e-cc04e3d84264"
  };

  // District ID mapping for API integration
  static Map<String, int> districtIds = {
    "Kampala": 1,
    "Masaka": 2,
    "Kabale": 3,
    "Fortportal": 4,
  };

  // Helper methods
  static String getRegionGuid(String region) {
    final normalized = region.trim().toUpperCase();
    for (final entry in regionGuids.entries) {
      if (entry.key.toUpperCase() == normalized) return entry.value;
    }
    return regionGuids["Head Office"]!;
  }

  static int getDistrictId(String district) {
    final normalized = district.trim().toUpperCase();
    for (final entry in districtIds.entries) {
      if (entry.key.toUpperCase() == normalized) return entry.value;
    }
    return districtIds["Kampala"]!;
  }

  static String getRegionName(String guid) {
    for (var entry in regionGuids.entries) {
      if (entry.value == guid) {
        return entry.key;
      }
    }
    // Never silently relabel an unknown/new API region as Head Office.
    return guid;
  }

  static String getDistrictName(int id) {
    for (var entry in districtIds.entries) {
      if (entry.value == id) {
        return entry.key;
      }
    }
    // Preserve an unknown/new API district instead of showing Kampala.
    return id.toString();
  }

  /// Get districts filtered by selected region
  static List<String> getDistrictsByRegion(String region) {
    if (region.isEmpty || region == "Head Office") {
      return allDistricts; // Return all districts for Head Office
    }

    return allDistricts.where((district) {
      return districtToRegion[district] == region;
    }).toList();
  }

  /// Get region for a specific district
  static String getRegionForDistrict(String district) {
    return districtToRegion[district] ?? "CENTRAL";
  }

  static String getRegionNameForDistrictId(int? districtId,
      {String fallbackGuid = ''}) {
    if (districtId != null) {
      final district = getDistrictName(districtId);
      final region = districtToRegion[district];
      if (region != null) return region;
    }
    return getRegionName(fallbackGuid);
  }

  static String getRegionGuidForDistrictId(int? districtId,
      {String fallbackGuid = ''}) {
    final region =
        getRegionNameForDistrictId(districtId, fallbackGuid: fallbackGuid);
    return regionGuids[region] ?? fallbackGuid;
  }

  /// Qualification Master - Standard qualifications list
  static const List<String> qualifications = [
    "Pharmacist",
    "Pharmacy Technician",
    "Nursing Officer",
    "Clinical Officer",
    "Medical Doctor",
    "Veterinary Doctor",
    "Dispenser",
    "Herbalist",
    "Drug Shop Operator",
    "Other"
  ];
}
