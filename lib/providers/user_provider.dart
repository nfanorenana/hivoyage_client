import 'package:flutter/foundation.dart';
import 'package:hivoyage/domain/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User();

  get user {
    return _user;
  }

  set user(dynamic user) {
    _user = user;
    notifyListeners();
  }
}
