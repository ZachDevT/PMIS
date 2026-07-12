import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pmis/features/pmis/rts/controllers/RtsController.dart';
import 'package:pmis/features/pmis/rts/widgets/RtsForm.dart';

void main() {
  group('RTS Form Tests', () {
    late RtsController controller;

    setUp(() {
      Get.testMode = true;
      controller = RtsController();
      Get.put(controller);
    });

    tearDown(() {
      Get.delete<RtsController>();
      Get.reset();
    });

    testWidgets('Number of Participants field should exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: RtsForm(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Number of Participants'), findsOneWidget);
    });

    testWidgets('Venue/Location field should exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: RtsForm(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Venue/Location'), findsOneWidget);
    });

    test('numberOfParticipantsController should exist in controller', () {
      expect(controller.numberOfParticipantsController, isNotNull);
      
      controller.numberOfParticipantsController.text = '50';
      expect(controller.numberOfParticipantsController.text, '50');
    });
  });
}
