import 'package:flutter_test/flutter_test.dart';

import 'package:sukoon_app/main.dart';

void main() {
  testWidgets('App loads splash route', (WidgetTester tester) async {
    await tester.pumpWidget(const SukoonApp());
    await tester.pump();
    expect(find.byType(SukoonApp), findsOneWidget);
  });
}
