import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/shiftmarket/controllers/ShiftMarketController.dart';
import 'package:pmis/features/pmis/shiftmarket/widgets/ShiftMarketForm.dart';
import 'package:pmis/features/pmis/shiftmarket/models/ShiftMarketModel.dart';

void main() {
  group('Shift Market Form Tests', () {
    late ShiftMarketController controller;

    setUp(() {
      Get.testMode = true;
      controller = ShiftMarketController();
      Get.put(controller);
    });

    tearDown(() {
      Get.delete<ShiftMarketController>();
      Get.reset();
    });

    testWidgets('Form should display "Market Name" instead of "Facility Name"',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: ShiftMarketForm(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find Market Name label
      expect(find.text('Market Name'), findsOneWidget);
      expect(find.text('Facility Name'), findsNothing);
    });

    testWidgets('Person Found at Facility field should exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: ShiftMarketForm(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Person Found at Facility should be present
      expect(find.text('Person Found at Facility'), findsOneWidget);
    });

    testWidgets('Removed fields should not be present',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: ShiftMarketForm(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // These fields should not exist
      expect(find.text('Person Name'), findsNothing);
      expect(find.text('Contact'), findsNothing);
      expect(find.text('Qualifications'), findsNothing);
      expect(find.text('Facility Status'), findsNothing);
    });

    test('ShiftMarketModel should have personFoundAtFacility field', () {
      final model = ShiftMarketModel(
        inspectionDate: '2024-01-01',
        inspectorName: 'Test Inspector',
        latitude: 0.0,
        longitude: 0.0,
        region: 'Central',
        district: 'Kampala',
        facilityName: 'Test Market',
        personFoundAtFacility: 'In-charge',
        categoryOfPremises: 'Shift Market',
        regulatoryActionTaken: 'None',
        consignmentsImpounded: '0',
        isSynced: false,
      );

      expect(model.personFoundAtFacility, 'In-charge');
      expect(model.facilityName, 'Test Market');
    });

    test('Controller should have selectedPersonFoundAtFacility variable', () {
      expect(controller.selectedPersonFoundAtFacility, isNotNull);

      controller.selectedPersonFoundAtFacility.value = 'In-charge';
      expect(controller.selectedPersonFoundAtFacility.value, 'In-charge');
    });
  });
}
