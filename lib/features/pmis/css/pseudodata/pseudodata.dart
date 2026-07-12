import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/features/pmis/css/models/card_dash_model.dart';

class PseudoData {
  final kpi = const <PseudoDataModel>[
    PseudoDataModel(
        icone: HugeIcons.strokeRoundedMedicineBottle02,
        feature: 'CSS',
        number: 12),
    PseudoDataModel(
        icone: HugeIcons.strokeRoundedMedicine02, feature: 'GPP', number: 111),
    PseudoDataModel(
        icone: HugeIcons.strokeRoundedDeliveryTracking01,
        feature: 'GDP',
        number: 121),
    PseudoDataModel(icone: Iconsax.activity, feature: 'PMSA', number: 82),
  ];
}
