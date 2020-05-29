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
}
