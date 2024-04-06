import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  GlobalKey<ScaffoldState>? _scaffoldKey; // Scaffold key

  ConnectivityResult get connectionStatus => _connectionStatus;

  void updateConnectionStatus(ConnectivityResult status) {
    _connectionStatus = status;
    notifyListeners();
  }

  void checkConnection() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    updateConnectionStatus(result);
  }

  void startMonitoring() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      updateConnectionStatus(result);
    });
  }

  void setScaffoldKey(GlobalKey<ScaffoldState>? key) {
    _scaffoldKey = key;
  }
}
