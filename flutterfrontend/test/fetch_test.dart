import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfrontend/fetch.dart';

void main() {
  testWidgets('Fetch widget', (WidgetTester tester) async {
    // Not working
    void setDrawProfile(bool dp) {}
    const token = 'tokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentoken';

    await tester.pumpWidget(DataFetchingWidget(token, setDrawProfile));
  }, skip: true);
}
