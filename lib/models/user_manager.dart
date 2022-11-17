import 'package:flutter_ecurie/models/user.dart';
class UserManager {
  static late User user;
  static bool isUserConnected = false;

  static connectUser() {
    isUserConnected = true;
    return isUserConnected;
  }
}