import 'package:get_storage/get_storage.dart';
import 'package:pmis/features/pmis/gdp/models/GdpModel.dart';

class GdpRepository {
  final box = GetStorage();

  /// Mimic an API call to fetch GDP activities.
  Future<List<GdpActivity>> fetchActivities() async {
    try {
      // Mimic network delay.
      await Future.delayed(const Duration(seconds: 1));
      // Return dummy data for demonstration.
      return [
        GdpActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'John Doe',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 1',
          facilityStatus: 'Closed',
          name: "Jane Doe",
          contactQualifications: 'Qualified',
          qualifications: 'Expert',
          categoryOfFacility: 'Hospital',
          facilityType: 'Public Facility',
          categoryOfDrugs: 'Human drugs',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
        GdpActivity(
          id: '2',
          inspectionDate: DateTime.now().subtract(const Duration(days: 2)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 2)),
          inspectorName: 'John Doe',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District B',
          facilityName: 'Facility 2',
          facilityStatus: 'Open',
          name: "Jane Doe",
          contactQualifications: 'Qualified',
          qualifications: 'Expert',
          categoryOfFacility: 'Pharmacy',
          facilityType: 'Private Facility',
          categoryOfDrugs: 'Medical Device',
          certificationStatus: 'Not Certified',
          recommendedForGpp: 'Not recommended for GPP certification',
        ),
         GdpActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'John Doe',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 1',
          facilityStatus: 'Closed',
          name: "Jane Doe",
          contactQualifications: 'Qualified',
          qualifications: 'Expert',
          categoryOfFacility: 'Hospital',
          facilityType: 'Public Facility',
          categoryOfDrugs: 'Human drugs',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
         GdpActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'John Doe',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 1',
          facilityStatus: 'Closed',
          name: "Jane Doe",
          contactQualifications: 'Qualified',
          qualifications: 'Expert',
          categoryOfFacility: 'Hospital',
          facilityType: 'Public Facility',
          categoryOfDrugs: 'Human drugs',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
         GdpActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'John Doe',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 1',
          facilityStatus: 'Opened',
          name: "Jane Doe",
          contactQualifications: 'Qualified',
          qualifications: 'Expert',
          categoryOfFacility: 'Hospital',
          facilityType: 'Public Facility',
          categoryOfDrugs: 'Human drugs',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
      ];
    } catch (e) {
      print('Error fetching GDP activities: $e');
      return [];
    }
  }

  /// Save a GDP activity locally when offline.
  Future<void> saveActivityLocally(GdpActivity activity) async {
    try {
      List storedActivities = box.read<List>('gdp_activities') ?? [];
      storedActivities.add(activity.toJson());
      await box.write('gdp_activities', storedActivities);
    } catch (e) {
      print('Error saving GDP activity locally: $e');
    }
  }

  /// Sync locally stored GDP activities to API when online.
  Future<void> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('gdp_activities') ?? [];
      if (storedActivities.isNotEmpty) {
        // API sync logic here.
        // If successful, remove the locally stored activities.
        await box.remove('gdp_activities');
      }
    } catch (e) {
      print('Error syncing local GDP activities: $e');
    }
  }

  /// Add a new GDP activity directly when there is network.
  Future<void> addActivity(GdpActivity activity) async {
    try {
      // API call to add activity.
      // If successful, log success.
      print('GDP Activity added successfully');
    } catch (e) {
      print('Error adding GDP activity: $e');
      // Optionally save locally if network call fails.
      await saveActivityLocally(activity);
    }
  }
}
