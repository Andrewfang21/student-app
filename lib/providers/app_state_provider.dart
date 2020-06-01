import "package:flutter/material.dart";
import "package:student_app/utils.dart";

class AppStateProvider with ChangeNotifier {
  String _activePageName;

  set activePageName(String activePageName) {
    _activePageName = parseEnumString(activePageName);
    notifyListeners();
  }

  get activePageName => _activePageName ?? "root";
}
