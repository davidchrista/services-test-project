import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/auth.dart';
import 'package:flutterfrontend/global.dart';
import 'package:flutterfrontend/mainwidget.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Global(),
      child: MaterialApp(
        title: 'Services Test',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Services Test'),
          ),
          body: WithAuth((Future<void> Function() logoutAction, UserProfile? user,
                  String? accessToken) =>
              MainWidget(logoutAction, user, accessToken)),
        ),
      ),
    );
  }
}
