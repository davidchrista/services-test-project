import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterfrontend/fetch.dart';
import 'package:flutterfrontend/global.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

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
    var global = context.watch<Global>();
    stdout.writeln(global.authInfo?.accessToken ?? '');
    return Column(
      mainAxisSize: _drawProfile ? MainAxisSize.min : MainAxisSize.max,
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
                    image: NetworkImage(
                        global.authInfo?.user.pictureUrl.toString() ?? ''),
                  ),
                ),
              )
            : Container(),
        _drawProfile ? const SizedBox(height: 6) : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${global.authInfo?.user.name}'),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: () async {
                await global.authInfo?.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
        _drawProfile ? const SizedBox(height: 6) : Container(),
        _drawProfile
            ? Text(
                'Token: ${global.authInfo?.accessToken != null ? '${global.authInfo!.accessToken.substring(0, 100)} ...' : ''}')
            : Container(),
        const SizedBox(height: 6),
        DataFetchingWidget(global.authInfo?.accessToken, _setDrawProfile),
      ],
    );
  }
}
