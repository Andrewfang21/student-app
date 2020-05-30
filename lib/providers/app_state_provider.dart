import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:student_app/models/user.dart";
import "package:student_app/utils.dart";

class AppStateProvider with ChangeNotifier {
  User _currentUser;
  String _activePageName;

  void setCurrentUser(FirebaseUser currentUser) {
    this._currentUser = User(
      uid: currentUser.uid,
      displayName: currentUser.displayName,
      email: currentUser.email,
      photoUrl: currentUser.photoUrl,
    );
  }

  User getCurrentUser() => this._currentUser;

  void setActivePageName(String activePageName) {
    this._activePageName = parseEnumString(activePageName);
    notifyListeners();
  }

  String getActivePageName() => this._activePageName ?? "root";
}
