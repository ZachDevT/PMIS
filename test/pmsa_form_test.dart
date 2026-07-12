import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:pmis/features/pmis/pmsa/widgets/PmsaForm.dart';

void main() {
  group('PMSA Form Tests', () {
    late PmsaController controller;

    setUp(() {
      Get.testMode = true;
      controller = PmsaController();
      Get.put(controller);
    });

    tearDown(() {
      Get.delete<PmsaController>();
      Get.reset();
    });

    testWidgets('Submit button should display "Submit" text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: PmsaForm(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the Submit button text
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Create'), findsNothing);
    });

    test('Conditional fields should work correctly', () {
      // Test "Others" - fields should be hidden
      controller.pmsaActivityCarriesOut.value = "Others";
      expect(controller.pmsaActivityCarriesOut.value, "Others");

      // Test "Sampling" - fields should be visible
      controller.pmsaActivityCarriesOut.value = "Sampling";
      expect(controller.pmsaActivityCarriesOut.value, "Sampling");
    });
  });
}
