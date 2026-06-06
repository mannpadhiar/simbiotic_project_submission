import 'package:flutter_test/flutter_test.dart';

import 'package:simproject/main.dart';

void main() {
  testWidgets('HireHub app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HireHubApp());
    await tester.pump();

    // Verify that HireHub title is displayed
    expect(find.text('HireHub'), findsOneWidget);
  });
}
