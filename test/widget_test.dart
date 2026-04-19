import 'package:flutter_test/flutter_test.dart';

import 'package:sukoon_app/main.dart';

void main() {
  testWidgets('App loads splash route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(MyApp), findsOneWidget);
  });
}
