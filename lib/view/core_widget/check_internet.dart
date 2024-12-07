
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

StreamSubscription? _subscription;
bool isConnect=false;
bool checkConnection() {
  _subscription = Connectivity().onConnectivityChanged.listen((result) {
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile)) {
      isConnect=true;
      print("trueeeeeeeeeeeeee");
    } else {
      isConnect=false;
      print("falseeeeeeeeeeee");

    }
  });
  return isConnect;
}