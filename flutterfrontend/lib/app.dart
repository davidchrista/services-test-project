import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/login.dart';
import 'package:flutterfrontend/mainwidget.dart';

const appScheme = 'flutterfrontend';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isBusy = false;
  late String errorMessage;

  Credentials? _credentials;
  late Auth0 auth0;

  @override
  void initState() {
    super.initState();

    auth0 =
        Auth0('dev-gzm0pgbh.us.auth0.com', 'Lc5xWjq3AmxXL4Nyhp9QWspQF2psuEUm');
    errorMessage = '';
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final Credentials credentials = await auth0
          .webAuthentication(scheme: appScheme)
          .login(audience: 'http://localhost:4000');

      setState(() {
        isBusy = false;
        _credentials = credentials;
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await auth0.webAuthentication(scheme: appScheme).logout();

    setState(() {
      _credentials = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Services Test'),
        ),
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : _credentials != null
                  ? MainWidget(logoutAction, _credentials?.user,
                      _credentials?.accessToken)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }
}
