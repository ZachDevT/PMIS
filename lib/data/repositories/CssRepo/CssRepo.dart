// repositories/CssRepo.dart
import 'package:get_storage/get_storage.dart';
import 'package:pmis/features/pmis/css/models/CssModel.dart';


class CssRepository {
  final box = GetStorage();

  /// Fetch activities (mimic API call).
  Future<List<CssActivity>> fetchActivities() async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      return [
        CssActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(Duration(hours: 1)),
          inspectorName: 'Segawa Innocent',
          gpsLocation: 'Lat: 0.0, Lon: 0.0',
          region: 'Nakawa',
          district: 'District A',
          facilityName: 'Facility 1',
          personFound: 'In-charge',
          name: 'Segawa Aaron',
          contactQualifications: 'Qualified',
          facilityStatus: 'Open',
          contact: '+256774567890',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Licensed',
          categoryOfDrugs: 'Human drugs',
          classOfDrugs: 'A',
          unregisteredDrugs: 'Not Present',
          conditionOfPremises: 'Good',
          recordKeeping: 'Excellent',
          actionTaken: 'No action taken',
        ),
      ];
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }

  /// Save activity locally when offline.
  Future<void> saveActivityLocally(CssActivity activity) async {
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
  Future<void> addActivity(CssActivity activity) async {
    try {
      // API call to add activity
      print('Activity added successfully');
    } catch (e) {
      print('Error adding activity: $e');
      // Optionally save locally if network call fails
      await saveActivityLocally(activity);
    }
  }
}
