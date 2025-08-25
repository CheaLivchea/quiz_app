import 'package:flutter/material.dart';
import 'package:quiz_app/features/profile/models/user_data.dart';

class UserProvider extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  void setUser(UserData user) {
    _userData = user;
    notifyListeners();
  }

  void clearUser() {
    _userData = null;
    notifyListeners();
  }
}
