import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pmis/data/models/QualificationModel.dart';
import 'package:pmis/data/services/qualification/QualificationService.dart';
import 'package:pmis/utils/helpers/master_data_refresh.dart';

class QualificationController extends GetxController {
  static QualificationController get instance => Get.find();

  final QualificationService _service = QualificationService();
  final GetStorage _storage = GetStorage();
  final qualifications = <QualificationModel>[].obs;
  final isLoading = false.obs;

  List<String> get names {
    final names = qualifications.map((item) => item.name).toList();
    if (!names.any((name) => name.toLowerCase() == 'other')) {
      names.add('Other');
    }
    return names;
  }

  int? idForName(String name) => qualifications
      .firstWhereOrNull((item) => item.name.toLowerCase() == name.toLowerCase())
      ?.id;

  QualificationModel? qualificationForId(int? id) =>
      qualifications.firstWhereOrNull((item) => item.id == id);

  String nameForId(dynamic id) {
    final parsedId = id is int ? id : int.tryParse(id?.toString() ?? '');
    return qualifications
            .firstWhereOrNull((item) => item.id == parsedId)
            ?.name ??
        '';
  }

  String displayName(dynamic apiName, dynamic id) {
    final name = apiName?.toString().trim() ?? '';
    return name.isNotEmpty ? name : nameForId(id);
  }

  @override
  void onInit() {
    super.onInit();
    final cached = _storage.read<List>('qualifications') ?? [];
    qualifications.assignAll(cached.map((item) =>
        QualificationModel.fromJson(Map<String, dynamic>.from(item))));
    fetchQualifications();
  }

  Future<void> fetchQualifications() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getQualifications();
      if (fetched.isEmpty) return;
      qualifications.assignAll(fetched);
      await _storage.write(
        'qualifications',
        fetched
            .map(
                (item) => {'id': item.id, 'code': item.code, 'name': item.name})
            .toList(),
      );
      await reloadControllersAfterMasterDataChange();
    } catch (error) {
      print('Error fetching qualifications: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
