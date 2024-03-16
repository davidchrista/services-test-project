import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/fetch.dart';

class MainWidget extends StatefulWidget {
  final Future<void> Function() logoutAction;
  final UserProfile? user;
  final String? accessToken;

  const MainWidget(this.logoutAction, this.user, this.accessToken,
      {final Key? key})
      : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool _drawProfile = true;

  void _setDrawProfile(bool d) {
    setState(() {
      _drawProfile = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    stdout.writeln(widget.accessToken ?? '');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _drawProfile
            ? Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image:
                        NetworkImage(widget.user?.pictureUrl.toString() ?? ''),
                  ),
                ),
              )
            : Container(),
        _drawProfile ? const SizedBox(height: 6) : Container(),
        Text('Name: ${widget.user?.name}'),
        _drawProfile ? const SizedBox(height: 6) : Container(),
        _drawProfile
            ? Text(
                'Token: ${widget.accessToken != null ? '${widget.accessToken!.substring(0, 100)} ...' : ''}')
            : Container(),
        const SizedBox(height: 6),
        ElevatedButton(
          onPressed: () async {
            await widget.logoutAction();
          },
          child: const Text('Logout'),
        ),
        const SizedBox(height: 6),
        DataFetchingWidget(widget.accessToken, _setDrawProfile),
      ],
    );
  }
}
