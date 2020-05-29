import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:student_app/models/user.dart";

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

  void deleteCurrentUser() => this._currentUser = null;

  User getCurrentUser() => this._currentUser;

  void setActivePageName(String activePageName) {
    this._activePageName = activePageName;
    notifyListeners();
  }

  String getActivePageName() => this._activePageName ?? "root";
}
