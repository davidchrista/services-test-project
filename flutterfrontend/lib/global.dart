import 'package:flutter/material.dart';
import 'package:flutterfrontend/auth.dart';

class Global extends ChangeNotifier {
  AuthInfo? authInfo;

  void setAuth(AuthInfo ai) {
    authInfo = ai;
    notifyListeners();
  }
}