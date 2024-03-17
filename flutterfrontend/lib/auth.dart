import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/global.dart';
import 'package:provider/provider.dart';

const appScheme = 'flutterfrontend';

class WithAuth extends StatefulWidget {
  final Widget Function(Future<void> Function(), UserProfile?, String?)
      createMain;

  const WithAuth(this.createMain, {super.key});

  @override
  State<WithAuth> createState() => _WithAuthState();
}

class Auth {
  final Future<void> Function() logout;
  final UserProfile user;
  final String accessToken;
  const Auth(this.logout, this.user, this.accessToken);
}

class _WithAuthState extends State<WithAuth> {
  bool isBusy = false;
  String errorMessage = '';

  Future<void> login(Global global) async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final Credentials credentials = await global.auth0
          .webAuthentication(scheme: appScheme)
          .login(audience: 'http://localhost:4000');

      Future<void> logout() async {
        await global.auth0.webAuthentication(scheme: appScheme).logout();
        global.clearAuth();
      }

      ;

      global.setAuth(Auth(logout, credentials.user, credentials.accessToken));

      setState(() {
        isBusy = false;
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var global = context.watch<Global>();

    return global.authInfo != null
        ? widget.createMain(global.authInfo!.logout, global.authInfo!.user,
            global.authInfo!.accessToken)
        : Center(
            child: isBusy
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await login(global);
                        },
                        child: const Text('Login'),
                      ),
                      Text(errorMessage),
                    ],
                  ));
  }
}
