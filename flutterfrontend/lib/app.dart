import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/login.dart';
import 'package:flutterfrontend/mainwidget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Services Test'),
        ),
        body: WithAuth((Future<void> Function() logoutAction, UserProfile? user,
                String? accessToken) =>
            MainWidget(logoutAction, user, accessToken)),
      ),
    );
  }
}
