import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login/login_ui/login_ui.dart';

class AuthState with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _nif = '';
  bool _loginSccessful = false;

  bool get loginSccessful => _loginSccessful;
  String get email => _email;
  String get password => _password;
  String get nif => _nif;

  void isLoginSccessful(bool loginSccessful) {
    _loginSccessful = loginSccessful;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setNif(String nif) {
    _nif = nif;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void clearState() {
    _email = '';
    _nif = '';
    _password = '';
    _loginSccessful = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Remove stored credentials from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Retrieve the stored token

      // Reset local state
      _email = '';
      _nif = '';
      _password = '';
      _loginSccessful = false;
      notifyListeners();

      if (token != null) {
        await prefs.remove('token');
        print("Logged out successfully from server");


        Provider.of<AuthState>(context, listen: false).clearState(); // Clear the cart state
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginUI()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginUI()),
            (Route<dynamic> route) => false,
      );
      print("Logout failed: $e");
    }
  }

}