import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class Connectionchecker {
  Future<bool> get isconnected;
}

class ConnectionCheckerImpl implements Connectionchecker {
  final InternetConnection internetConnection;

  ConnectionCheckerImpl({required this.internetConnection});
  @override
  Future<bool> get isconnected async =>
      await internetConnection.hasInternetAccess;
}
