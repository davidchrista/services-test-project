import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

const appScheme = 'flutterfrontend';

class WithAuth extends StatefulWidget {
  final Widget Function(Future<void> Function(), UserProfile?, String?)
      createMain;

  const WithAuth(this.createMain, {super.key});

  @override
  State<WithAuth> createState() => _WithAuthState();
}

class AuthInfo {
  final Future<void> Function() logoutAction;
  final UserProfile user;
  final String accessToken;
  const AuthInfo(this.logoutAction, this.user, this.accessToken);
}

class _WithAuthState extends State<WithAuth> {
  bool isBusy = false;
  late String errorMessage;

  late Auth0 auth0;

  AuthInfo? _authInfo;

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
        _authInfo =
            AuthInfo(logoutAction, credentials.user, credentials.accessToken);
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
      _authInfo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _authInfo != null
        ? widget.createMain(
            logoutAction, _authInfo!.user, _authInfo!.accessToken)
        : Center(
            child: isBusy
                ? const CircularProgressIndicator()
                : Login(loginAction, errorMessage));
  }
}

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError, {final Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await loginAction();
          },
          child: const Text('Login'),
        ),
        Text(loginError),
      ],
    );
  }
}
