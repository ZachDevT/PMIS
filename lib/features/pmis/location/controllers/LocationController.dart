import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/models/LocationModel.dart';
import 'package:pmis/data/services/location/LocationService.dart';
import 'package:pmis/utils/constants/regions_districts.dart';

class LocationController extends GetxController {
  static LocationController get instance => Get.find();

  final LocationService _locationService = LocationService();
  final GetStorage _storage = GetStorage();

  static const _regionsCacheKey = 'cached_regions';
  static const _districtsCacheKey = 'cached_districts';

  var regions = <RegionModel>[].obs;
  var districts = <DistrictModel>[].obs;

  var isLoading = false.obs;

  /// Returns just the region names for dropdowns
  List<String> get regionNames => regions.isNotEmpty
      ? regions.map((r) => r.regionName).toList()
      : RegionDistrictConstants.regions;

  /// Returns the parent region for a district selected from the API data.
  String getRegionForDistrict(String districtName) {
    if (districtName.isEmpty) return '';
    final district = districts.firstWhereOrNull(
      (d) => d.name.toLowerCase() == districtName.toLowerCase(),
    );
    if (district == null) {
      return RegionDistrictConstants.districtToRegion[districtName] ?? '';
    }
    return regions
            .firstWhereOrNull((r) => r.intRegion == district.regionId)
            ?.regionName ??
        '';
  }

  /// Returns district names filtered by selected region name
  List<String> getDistrictsForRegion(String regionName) {
    if (districts.isEmpty) {
      return regionName.isEmpty
          ? RegionDistrictConstants.allDistricts
          : RegionDistrictConstants.getDistrictsByRegion(regionName);
    }
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
    _loadCachedLocations();
    fetchLocations();
  }

  void _loadCachedLocations() {
    final cachedRegions = _storage.read<List>(_regionsCacheKey) ?? const [];
    final cachedDistricts = _storage.read<List>(_districtsCacheKey) ?? const [];

    regions.assignAll(cachedRegions.map((item) =>
        RegionModel.fromJson(Map<String, dynamic>.from(item as Map))));
    districts.assignAll(cachedDistricts.map((item) =>
        DistrictModel.fromJson(Map<String, dynamic>.from(item as Map))));

    if (regions.isNotEmpty || districts.isNotEmpty) {
      _updateConstants();
    }
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;

      // Fetch both simultaneously
      final results = await Future.wait([
        _locationService.getRegions(),
        _locationService.getDistricts(),
      ]);

      final fetchedRegions = results[0] as List<RegionModel>;
      final fetchedDistricts = results[1] as List<DistrictModel>;

      // Never replace usable cached dropdown data with an empty response.
      if (fetchedRegions.isNotEmpty) {
        regions.assignAll(fetchedRegions);
        await _storage.write(_regionsCacheKey,
            fetchedRegions.map((item) => item.toJson()).toList());
      }
      if (fetchedDistricts.isNotEmpty) {
        districts.assignAll(fetchedDistricts);
        await _storage.write(_districtsCacheKey,
            fetchedDistricts.map((item) => item.toJson()).toList());
      }

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
    RegionDistrictConstants.allDistricts =
        districts.map((d) => d.name).toList();

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
      final region =
          regions.firstWhereOrNull((r) => r.intRegion == district.regionId);
      if (region != null) {
        newDistrictToRegion[district.name] = region.regionName;
      }
    }

    RegionDistrictConstants.districtIds = newDistrictIds;
    RegionDistrictConstants.districtToRegion = newDistrictToRegion;
  }
}
