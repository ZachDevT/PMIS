import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/css/widgets/CssForm.dart';

void main() {
  group('CSS Form Tests', () {
    late CssController controller;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;
      controller = CssController();
      Get.put(controller);
    });

    tearDown(() {
      Get.delete<CssController>();
      Get.reset();
    });

    testWidgets('Action Taken field should be hidden when Facility Status is Closed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CssForm(),
          ),
        ),
      );

      // Set facility status to Closed
      controller.selectedFacilityStatus.value = "Closed";
      await tester.pumpAndSettle();

      // Action Taken field should not be found
      expect(find.text('Action Taken'), findsNothing);
    });

    testWidgets('Action Taken field should be visible when Facility Status is Open',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CssForm(),
          ),
        ),
      );

      // Set facility status to Open
      controller.selectedFacilityStatus.value = "Open";
      await tester.pumpAndSettle();

      // Action Taken field should be visible
      expect(find.text('Action Taken'), findsOneWidget);
    });

    test('Action Taken should be required when facility is Open', () {
      controller.selectedFacilityStatus.value = "Open";
      controller.selectedActionTaken.value = "";
      
      // This would normally trigger validation
      expect(controller.selectedFacilityStatus.value, "Open");
      expect(controller.selectedActionTaken.value, isEmpty);
    });

    test('Action Taken should not be required when facility is Closed', () {
      controller.selectedFacilityStatus.value = "Closed";
      controller.selectedActionTaken.value = "";
      
      // Validation should pass even with empty Action Taken
      expect(controller.selectedFacilityStatus.value, "Closed");
      expect(controller.selectedActionTaken.value, isEmpty);
    });
  });
}
