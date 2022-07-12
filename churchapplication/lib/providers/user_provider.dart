import 'package:churchapplication/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    email: '',
    username: '',
    uid: '',
  );

  User get user => _user;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
