import 'package:flutter_ecurie/models/user.dart';
class UserManager {
  static late User user;
  static bool _isUserConnected = false;

  static connectUser() {
    _isUserConnected = true;
    return _isUserConnected;
  }
}