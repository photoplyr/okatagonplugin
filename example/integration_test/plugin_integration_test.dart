// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:okatagonplugin/okatagonplugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('OkatagonAgentView test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OkatagonAgentView(
            agentId: 'test-agent-id',
          ),
        ),
      ),
    );

    // Wait for the widget to load
    await tester.pumpAndSettle();

    // Verify the widget is rendered
    expect(find.byType(OkatagonAgentView), findsOneWidget);
  });
}
