import 'package:get_storage/get_storage.dart';
import 'package:pmis/features/pmis/pmsa/models/PmsaModel.dart';

class PmsaRepository {
  final box = GetStorage();

  /// Mimic an API call to fetch PMSA activities.
  Future<List<PmsaActivity>> fetchActivities() async {
    try {
      // Mimic network delay.
      await Future.delayed(const Duration(seconds: 1));
      // Return dummy data for demonstration.
      return [
        PmsaActivity(
          id: '1',
          inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 1)),
          inspectorName: 'Alice Smith',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District A',
          facilityName: 'Facility A',
          facilityStatus: 'Closed',
          personFoundAtFacility: 'In-charge',
          name: 'Bob Johnson',
          contact: '+123456789',
          qualifications: 'Qualified',
          categoryOfFacility: 'Hospital',
          licensedStatus: 'Licensed',
          pmsaActivityCarriesOut: 'Sampling',
          categoryOfDrugs: 'Human drugs',
          categoryOfProductSamples: 'Medical Device',
          productSampledName: 'Device X',
          numberOfSamplesCollected: 5,
          batchNumberOfSample: 'Batch001',
          productBeingFollowedUp: 'Device X',
          commentOnOverallFollowUp: 'All good',
          productComplaintInvestigated: 'No complaint',
          specifyActivity: 'None',
        ),
        PmsaActivity(
          id: '2',
          inspectionDate: DateTime.now().subtract(const Duration(days: 2)),
          inspectionTime: DateTime.now().subtract(const Duration(hours: 2)),
          inspectorName: 'Alice Smith',
          gpsLocation: 'Lat: 12.34, Lon: 56.78',
          region: 'Gulu',
          district: 'District B',
          facilityName: 'Facility B',
          facilityStatus: 'Open',
          personFoundAtFacility: 'Attendant/Operator',
          name: 'Carol Williams',
          contact: '+987654321',
          qualifications: 'Expert',
          categoryOfFacility: 'Clinic',
          licensedStatus: 'Un-Licensed',
          pmsaActivityCarriesOut: 'Follow-up on recall',
          categoryOfDrugs: 'Veterinary drugs',
          categoryOfProductSamples: 'Veterinary drugs',
          productSampledName: 'Drug Y',
          numberOfSamplesCollected: 10,
          batchNumberOfSample: 'Batch002',
          productBeingFollowedUp: 'Drug Y',
          commentOnOverallFollowUp: 'Needs attention',
          productComplaintInvestigated: 'Complaint recorded',
          specifyActivity: 'Follow-up',
        ),
      ];
    } catch (e) {
      print('Error fetching PMSA activities: $e');
      return [];
    }
  }

  /// Save a PMSA activity locally when offline.
  Future<void> saveActivityLocally(PmsaActivity activity) async {
    try {
      List storedActivities = box.read<List>('pmsa_activities') ?? [];
      storedActivities.add(activity.toJson());
      await box.write('pmsa_activities', storedActivities);
    } catch (e) {
      print('Error saving PMSA activity locally: $e');
    }
  }

  /// Sync locally stored PMSA activities to API when online.
  Future<void> syncLocalActivities() async {
    try {
      List storedActivities = box.read<List>('pmsa_activities') ?? [];
      if (storedActivities.isNotEmpty) {
        // API sync logic here.
        // If successful, remove the locally stored activities.
        await box.remove('pmsa_activities');
      }
    } catch (e) {
      print('Error syncing local PMSA activities: $e');
    }
  }

  /// Add a new PMSA activity directly when there is network.
  Future<void> addActivity(PmsaActivity activity) async {
    try {
      // API call to add activity.
      // If successful, log success.
      print('PMSA Activity added successfully');
    } catch (e) {
      print('Error adding PMSA activity: $e');
      // Optionally save locally if network call fails.
      await saveActivityLocally(activity);
    }
  }
}
