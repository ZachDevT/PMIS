import 'package:flutter/material.dart';
import 'package:pmis/features/pmis/css/models/card_dash_model.dart';


class PseudoData{
  final kpi = const <PseudoDataModel>[
    PseudoDataModel(icone: Icons.add_chart, feature: 'CSS', number: 12),
    PseudoDataModel(icone: Icons.medical_services, feature: 'GPP', number: 111),
    PseudoDataModel(icone: Icons.local_shipping, feature: 'GDP', number: 121),
    PseudoDataModel(icone: Icons.alarm, feature: 'PMSA', number: 82),

  ];
}