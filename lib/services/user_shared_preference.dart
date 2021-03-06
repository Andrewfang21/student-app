import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";
import "package:student_app/models/user.dart";

class UserSharedPreference {
  static final String key = "user";

  static Future<UserModel> getActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) != null
        ? UserModel.fromJson(json.decode(prefs.getString(key)))
        : null;
  }

  static Future<void> setActiveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      key,
      json.encode(user.toJson()),
    );
  }

  static Future<void> deleteActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
