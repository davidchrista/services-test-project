/// -----------------------------------
///          External Packages
/// -----------------------------------

import 'dart:convert';
import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const appScheme = 'flutterfrontend';

/// -----------------------------------
///           Profile Widget
/// -----------------------------------

class DataFetchingWidget extends StatefulWidget {
  final String? token;

  const DataFetchingWidget(this.token, {super.key});

  @override
  State<DataFetchingWidget> createState() => _DataFetchingWidgetState();
}

class _DataFetchingWidgetState extends State<DataFetchingWidget> {
  String? _url;
  String? _data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Enter URL',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _url = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_url != null && _url!.isNotEmpty) {
              _fetchData();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid URL')),
              );
            }
          },
          child: const Text('Fetch'),
        ),
        const SizedBox(height: 20),
        _data != null
            ? Text(
                _data!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              )
            : Container(),
      ],
    );
  }

  void _fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse(_url!),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        // var jsonData = jsonDecode(response.body);
        setState(() {
          // _data = jsonData.toString();
          _data = response.body;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

class Main extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final UserProfile? user;
  final String? accessToken;

  const Main(this.logoutAction, this.user, this.accessToken, {final Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    stdout.writeln(accessToken ?? '');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(user?.pictureUrl.toString() ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: ${user?.name}'),
        const SizedBox(height: 24),
        Text(
            'Token: ${accessToken != null ? '${accessToken!.substring(0, 100)} ...' : ''}'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {
            await logoutAction();
          },
          child: const Text('Logout'),
        ),
        DataFetchingWidget(accessToken),
      ],
    );
  }
}

/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError, {final Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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

/// -----------------------------------
///                 App
/// -----------------------------------

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// -----------------------------------
///              App State
/// -----------------------------------

class _MyAppState extends State<MyApp> {
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
                  ? Main(logoutAction, _credentials?.user,
                      _credentials?.accessToken)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }
}
