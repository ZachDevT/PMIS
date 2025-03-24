import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tracks the current page (0: ServicePlans, 1: personal info, 2: payment)
final currentPageProvider = StateProvider<int>((ref) => 0);

// Tracks the selected ServicePlan plan
// final selectedPlanProvider = StateProvider<ServicePlan?>((ref) => null);
