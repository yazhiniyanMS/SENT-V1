import 'package:flutter_test/flutter_test.dart';

import 'package:sentinel_x/app.dart';

void main() {
  testWidgets('SentinelXApp launches to the dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SentinelXApp());
    await tester.pump();

    expect(find.text('SENTINEL-X'), findsOneWidget);
  });
}
