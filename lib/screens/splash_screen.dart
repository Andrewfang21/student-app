import "dart:async";

import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/enums.dart";
import "package:student_app/utils.dart";

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
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      if (currentUser != null) {
        Provider.of<AppStateProvider>(context, listen: false)
          ..setCurrentUser(currentUser)
          ..setActivePageName(PageName.Balance.toString());

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
