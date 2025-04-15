import 'package:get_storage/get_storage.dart';
import 'package:pmis/features/pmis/gpp/models/GppModel.dart';

class GppRepository {
  final box = GetStorage();

  /// Mimic an API call to fetch activities.
  Future<List<GppActivity>> fetchActivities() async {
    try {
      // Mimic network delay
      await Future.delayed(const Duration(seconds: 1));
      // Return dummy data for demonstration
      return [
        GppActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'Segawa Innocent',
          gpsLocation: 'Lat: 0.0, Lon: 0.0',
          region: 'Nakawa',
          district: 'District A',
          facilityName: 'Facility 1',
          name: "Segawa Aaroon",
          personFound: 'Incharge',
          contactQualifications: 'Qualified',
          facilityStatus: 'Closed',
          contact: '+256774567890',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Licensed',
          categoryOfDrugs: 'Human drugs',
          facilityType: 'Public Facility',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
        GppActivity(
          id: '2',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'Segawa Innocent',
          gpsLocation: 'Lat: 0.0, Lon: 0.0',
          region: 'Kampala',
          district: 'District A',
          facilityName: 'Facility 2',
          name: "Segawa Aaroon",
          personFound: 'Incharge',
          contactQualifications: 'Qualified',
          facilityStatus: 'Open',
          contact: '+256774567890',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Not Licensed',
          categoryOfDrugs: 'Human drugs',
          facilityType: 'Public Facility',
          certificationStatus: 'Not Certified',
          recommendedForGpp: 'GPP certification',
        ),
        GppActivity(
          id: '3',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'Segawa Innocent',
          gpsLocation: 'Lat: 0.0, Lon: 0.0',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 3',
          name: "Segawa Aaroon",
          personFound: 'Incharge',
          contactQualifications: 'Not Qualified',
          facilityStatus: 'Closed',
          contact: '+256774567890',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Not Licensed',
          categoryOfDrugs: 'Human drugs',
          facilityType: 'Public Facility',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
        GppActivity(
          id: '4',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'Bazeketta Datsun',
          gpsLocation: 'Lat: 0.0, Lon: 0.0',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 4',
          name: "Segawa Aaroon",
          personFound: 'Incharge',
          contactQualifications: 'Not Qualified',
          facilityStatus: 'Closed',
          contact: '+256774567890',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Not Licensed',
          categoryOfDrugs: 'Human drugs',
          facilityType: 'Public Facility',
          certificationStatus: 'Certified',
          recommendedForGpp: 'GPP certification',
        ),
        GppActivity(
          id: '5',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'Eric Kasozi',
          gpsLocation: 'Lat: 0.0, Lon: 0.0',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility 5',
          name: "Segawa Aaroon",
          personFound: 'Incharge',
          contactQualifications: 'Not Qualified',
          facilityStatus: 'Open',
          contact: '+256774567890',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Licensed',
          categoryOfDrugs: 'Human drugs',
          facilityType: 'Public Facility',
          certificationStatus: 'Not Certified',
          recommendedForGpp: 'GPP certification',
        ),
      ];
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }

  /// Save activity locally when offline.
  Future<void> saveActivityLocally(GppActivity activity) async {
    try {
      List storedActivities = box.read<List>('activities') ?? [];
      storedActivities.add(activity.toJson());
      await box.write('activities', storedActivities);
    } catch (e) {
      print('Error saving activity locally: $e');
    }
  }

  /// Sync locally stored activities to API when online.
  Future<void> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('activities') ?? [];
      if (storedActivities.isNotEmpty) {
        // API sync logic here.
        // If successful:
        await box.remove('activities');
      }
    } catch (e) {
      print('Error syncing local activities: $e');
    }
  }

  /// Add a new activity directly when there is network.
  Future<void> addActivity(GppActivity activity) async {
    try {
      // API call to add activity
      // If successful:
      print('Activity added successfully');
    } catch (e) {
      print('Error adding activity: $e');
      // Optionally save locally if network call fails
      await saveActivityLocally(activity);
    }
  }
}
