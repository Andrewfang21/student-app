import "dart:async";

import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/services/user_shared_preference.dart";
import "package:student_app/models/user.dart";
import "package:student_app/enums.dart";

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initTimer();
  }

  void _initTimer() {
    Timer(Duration(seconds: 3), () async {
      final FirebaseUser firebaseUser =
          await FirebaseAuth.instance.currentUser();
      final User currentUser = await UserSharedPreference.getActiveUser();

      if (firebaseUser != null && currentUser != null) {
        Provider.of<UserProvider>(context, listen: false).currentUser =
            currentUser;
        Provider.of<AppStateProvider>(context, listen: false).activePageName =
            PageName.Balance.toString();

        Navigator.of(context)
            .pushReplacementNamed(Routes.HomeScreen.toString());
      } else {
        Navigator.of(context).pushReplacementNamed(
          Routes.LoginScreen.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Insert Logo Here",
            style: TextStyle(fontSize: 60),
          ),
        ),
      ),
    );
  }
}
