import 'package:get/get.dart';
import 'package:pmis/data/models/LocationModel.dart';
import 'package:pmis/data/services/location/LocationService.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

class LocationController extends GetxController {
  static LocationController get instance => Get.find();

  final LocationService _locationService = LocationService();

  var regions = <RegionModel>[].obs;
  var districts = <DistrictModel>[].obs;

  var isLoading = false.obs;

  /// Returns just the region names for dropdowns
  List<String> get regionNames => regions.map((r) => r.regionName).toList();

  /// Returns district names filtered by selected region name
  List<String> getDistrictsForRegion(String regionName) {
    if (regionName.isEmpty) return districts.map((d) => d.name).toList();
    // Find the regionId GUID for this region name
    final region = regions.firstWhereOrNull(
      (r) => r.regionName.toLowerCase() == regionName.toLowerCase(),
    );
    if (region == null) return districts.map((d) => d.name).toList();
    return districts
        .where((d) => d.regionId == region.intRegion)
        .map((d) => d.name)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;

      // Fetch both simultaneously
      final results = await Future.wait([
        _locationService.getRegions(),
        _locationService.getDistricts(),
      ]);

      regions.assignAll(results[0] as List<RegionModel>);
      districts.assignAll(results[1] as List<DistrictModel>);

      _updateConstants();
    } catch (e) {
      print('Error fetching locations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateConstants() {
    // 1. Update lists of names
    RegionDistrictConstants.regions = regions.map((r) => r.regionName).toList();
    RegionDistrictConstants.allDistricts = districts.map((d) => d.name).toList();

    // 2. Update mappings
    Map<String, String> newRegionGuids = {};
    for (var region in regions) {
      newRegionGuids[region.regionName] = region.intRegion;
    }
    RegionDistrictConstants.regionGuids = newRegionGuids;

    Map<String, int> newDistrictIds = {};
    Map<String, String> newDistrictToRegion = {};
    for (var district in districts) {
      newDistrictIds[district.name] = district.id;

      // Find the region name for this district's regionId
      final region = regions.firstWhereOrNull((r) => r.intRegion == district.regionId);
      if (region != null) {
        newDistrictToRegion[district.name] = region.regionName;
      }
    }

    RegionDistrictConstants.districtIds = newDistrictIds;
    RegionDistrictConstants.districtToRegion = newDistrictToRegion;
  }
}
