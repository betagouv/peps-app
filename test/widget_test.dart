import 'package:app/try_contact_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Contact widget displays title', (WidgetTester tester) async {

    final TryContactDialog contactDialog = TryContactDialog(
      title: 'Test title',
      body: 'Test body',
      answers: [{'Test question': 'Test answer'}],
      practiceId: 'Test practice ID',
    );
    await tester.pumpWidget(MaterialApp(
      title: 'Test Material app',
      home: contactDialog,
    ));

    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('Test body'), findsOneWidget);
  });
}
