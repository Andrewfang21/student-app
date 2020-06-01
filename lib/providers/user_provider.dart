import "package:flutter/material.dart";
import "package:student_app/models/user.dart";

class UserProvider with ChangeNotifier {
  User _currentUser;

  set currentUser(User user) => _currentUser = User(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
      );

  get currentUser => _currentUser;
}
