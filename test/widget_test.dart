import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/features/circle/presentation/widgets/circle_empty_state.dart';

void main() {
  testWidgets('CircleEmptyState renders invite prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CircleEmptyState(onInviteTap: () {})),
      ),
    );

    expect(find.text('Invite your first person'), findsOneWidget);
    expect(find.text('Invite'), findsOneWidget);
  });
}
