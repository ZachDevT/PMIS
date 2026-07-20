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
    "Wakiso",
    "Mukono",
    "Masaka",
    "Mbarara",
    "Kabale",
    "Fortportal",
    "Kasese",
    "Mbale",
    "Soroti",
    "Gulu",
    "Lira",
    "Arua"
  ];

  // Legacy - kept for backward compatibility
  static List<String> get districts => allDistricts;

  // District-to-Region mapping
  static Map<String, String> districtToRegion = {
    "Kampala": "CENTRAL",
    "Wakiso": "CENTRAL",
    "Mukono": "CENTRAL",
    "Masaka": "CENTRAL",
    "Mbarara": "WESTERN",
    "Kabale": "WESTERN",
    "Fortportal": "WESTERN",
    "Kasese": "WESTERN",
    "Mbale": "EASTERN",
    "Soroti": "EASTERN",
    "Gulu": "NORTHERN",
    "Lira": "NORTHERN",
    "Arua": "NORTHERN",
  };

  // Region GUID mapping for API integration
  static Map<String, String> regionGuids = {
    "Head Office": "deaf2c98-3dbb-489f-bdea-9e5fd49eec78",
    "CENTRAL": "deaf2c98-3dbb-489f-bdea-9e5fd49eec78",
    "EASTERN": "57a2afce-98b8-48b2-984e-cc04e3d84264",
    "SOUTHERN": "12345678-1234-1234-1234-123456789012",
    "WESTERN": "87654321-4321-4321-4321-210987654321",
    "NORTHERN": "12345678-1234-1234-1234-123456789012"
  };

  // District ID mapping for API integration
  static Map<String, int> districtIds = {
    "Kampala": 1,
    "Wakiso": 2,
    "Mukono": 3,
    "Masaka": 4,
    "Mbarara": 5,
    "Kabale": 6,
    "Fortportal": 7,
    "Kasese": 8,
    "Mbale": 9,
    "Soroti": 10,
    "Gulu": 11,
    "Lira": 12,
    "Arua": 13,
  };

  // Helper methods
  static String getRegionGuid(String region) {
    return regionGuids[region] ?? regionGuids["Head Office"]!;
  }

  static int getDistrictId(String district) {
    return districtIds[district] ?? districtIds["Kampala"]!;
  }

  static String getRegionName(String guid) {
    for (var entry in regionGuids.entries) {
      if (entry.value == guid) {
        return entry.key;
      }
    }
    return "Head Office";
  }

  static String getDistrictName(int id) {
    for (var entry in districtIds.entries) {
      if (entry.value == id) {
        return entry.key;
      }
    }
    return "Kampala";
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
