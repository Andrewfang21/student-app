import "package:flutter/foundation.dart";

class User {
  String uid;
  String displayName;
  String email;
  String photoUrl;

  User({
    @required this.uid,
    @required this.displayName,
    @required this.email,
    @required this.photoUrl,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        displayName = json["name"],
        email = json["email"],
        photoUrl = json["photoUrl"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": displayName,
        "email": email,
        "photoUrl": photoUrl,
      };
}
