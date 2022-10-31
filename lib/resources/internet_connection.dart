import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  static Future<bool> checkInternet() async {
    final connection = await Connectivity().checkConnectivity();

    if (connection == ConnectivityResult.mobile ||
        connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }
}
