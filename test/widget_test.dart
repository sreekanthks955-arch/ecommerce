import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_app/main.dart';

void main() {
  testWidgets('ShopEase opens on its splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopEaseApp());

    expect(find.text('ShopEase'), findsOneWidget);
    expect(find.text('Flutter Demo Home Page'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1200));
  });
}
