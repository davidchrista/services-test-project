import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfrontend/app.dart';

void main() {
  testWidgets('App widget has right AppBar title', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Services Test'), findsOneWidget);
  });
}
