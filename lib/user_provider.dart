import 'package:flutter/material.dart';
import 'user.dart'; // Import the User class

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners(); // Notify all listeners when the user changes
  }

  void clearUser() {
    _user = null;
    notifyListeners(); // Notify all listeners when the user is cleared
  }
}
