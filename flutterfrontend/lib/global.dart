import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfrontend/auth.dart';

class Global extends ChangeNotifier {
  var auth0 = Auth0('dev-gzm0pgbh.us.auth0.com', 'Lc5xWjq3AmxXL4Nyhp9QWspQF2psuEUm');
  Auth? authInfo;

  void setAuth(Auth ai) {
    authInfo = ai;
    notifyListeners();
  }

  void clearAuth() {
    authInfo = null;
    notifyListeners();
  }
}