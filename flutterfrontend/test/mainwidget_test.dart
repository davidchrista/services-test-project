import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfrontend/auth.dart';
import 'package:flutterfrontend/global.dart';
import 'package:flutterfrontend/mainwidget.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('MainWidget shows right initial widgets',
      (WidgetTester tester) async {
    await pumpMainWidget(tester);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Fetch'), findsOneWidget);
  });
}

Future<void> pumpMainWidget(WidgetTester tester) async {
  var global = Global();
  var auth = Auth(() async => {}, const UserProfile(sub: 'user'),
      'tokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentokentoken');
  global.setAuth(auth);
  await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => global,
      child: const MaterialApp(home: Scaffold(body: MainWidget()))));
}
