import 'package:flutter/cupertino.dart';

class UserState extends ChangeNotifier {
  String? _userID;

  String? get userID => _userID;

  set userID(String? value) {
    if (_userID != value) {
      _userID = value;
      notifyListeners();
    }
  }

  void clear() {
    _userID = null;
    notifyListeners();
  }

}
