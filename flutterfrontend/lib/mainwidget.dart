import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/fetch.dart';

class MainWidget extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final UserProfile? user;
  final String? accessToken;

  const MainWidget(this.logoutAction, this.user, this.accessToken,
      {final Key? key})
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
