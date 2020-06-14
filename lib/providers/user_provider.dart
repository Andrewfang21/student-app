import "package:flutter/material.dart";
import "package:student_app/models/user.dart";

class UserProvider with ChangeNotifier {
  UserModel _currentUser;

  set currentUser(UserModel user) => _currentUser = UserModel(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
      );

  get currentUser => _currentUser;

  get currentUserID => _currentUser.uid;
}
