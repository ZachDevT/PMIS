/// Dynamic constants for regions and districts across all PMIS modules
/// This ensures consistency and maintainability across the application

class RegionDistrictConstants {
  // Region constants
  static const List<String> regions = [
    "Head Office",
    "CENTRAL",
    "EASTERN", 
    "SOUTHERN",
    "WESTERN",
    "NORTHERN"
  ];

  // District constants
  static const List<String> districts = [
    "Kampala",
    "Masaka", 
    "Kabale",
    "Fortportal"
  ];

  // Region GUID mapping for API integration
  static const Map<String, String> regionGuids = {
    "Head Office": "deaf2c98-3dbb-489f-bdea-9e5fd49eec78",
    "CENTRAL": "deaf2c98-3dbb-489f-bdea-9e5fd49eec78",
    "EASTERN": "57a2afce-98b8-48b2-984e-cc04e3d84264",
    "SOUTHERN": "12345678-1234-1234-1234-123456789012",
    "WESTERN": "87654321-4321-4321-4321-210987654321",
    "NORTHERN": "12345678-1234-1234-1234-123456789012"
  };

  // District ID mapping for API integration
  static const Map<String, int> districtIds = {
    "Kampala": 1,
    "Masaka": 2,
    "Kabale": 3,
    "Fortportal": 4
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
}
