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
          body: const WithAuth(child: MainWidget()),
        ),
      ),
    );
  }
}
