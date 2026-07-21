import 'package:get/get.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/enforcement/controllers/EnforcementController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/features/pmis/sensitizationmeeting/controllers/SensitizationMeetingController.dart';
import 'package:pmis/features/pmis/shiftmarket/controllers/ShiftMarketController.dart';

Future<void> reloadControllersAfterMasterDataChange() async {
  final reloads = <Future<void>>[];
  if (Get.isRegistered<CssController>()) {
    reloads.add(Get.find<CssController>().loadActivities());
  }
  if (Get.isRegistered<GppController>()) {
    reloads.add(Get.find<GppController>().loadActivities());
  }
  if (Get.isRegistered<GdpController>()) {
    reloads.add(Get.find<GdpController>().loadActivities());
  }
  if (Get.isRegistered<PmsaController>()) {
    reloads.add(Get.find<PmsaController>().loadActivities());
  }
  if (Get.isRegistered<EnforcementController>()) {
    reloads.add(Get.find<EnforcementController>().loadActivities());
  }
  if (Get.isRegistered<ShiftMarketController>()) {
    reloads.add(Get.find<ShiftMarketController>().loadActivities());
  }
  if (Get.isRegistered<RtsController>()) {
    reloads.add(Get.find<RtsController>().loadActivities());
  }
  if (Get.isRegistered<SensitizationMeetingController>()) {
    reloads.add(Get.find<SensitizationMeetingController>().loadActivities());
  }
  await Future.wait(reloads);
}
