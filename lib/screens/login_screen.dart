import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/enums.dart";
import "package:student_app/services.dart";

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;

  _handleGoogleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        googleSignIn.signOut();
      }
      GoogleSignInAccount googleSignInUser = await googleSignIn.signIn();
      if (googleSignInUser == null) {
        throw "Please login using your Google Account";
      }

      setState(() => _isLoading = true);
      FirebaseUser currentUser = await signInFirebaseWithGoogle(googleSignIn);
      setState(() => _isLoading = false);

      Provider.of<AppStateProvider>(context, listen: false)
        ..setCurrentUser(currentUser)
        ..setActivePageName(PageName.Balance.toString());

      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).pushReplacementNamed(
        Routes.HomeScreen.toString(),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (context) => Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Insert Logo Here"),
              SizedBox(height: 180.0),
              Container(
                margin:
                    const EdgeInsets.only(top: 50.0, left: 50.0, right: 50.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: OutlineButton(
                          onPressed: () => _handleGoogleSignIn(context),
                          child:
                              Row(children: _getWidgetsBasedOnLoadingStatus()),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getWidgetsBasedOnLoadingStatus() {
    List<Widget> widgets = [];
    if (_isLoading) {
      widgets.add(Container(
        margin: EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 112.0,
        ),
        child: CircularProgressIndicator(),
      ));
    } else {
      widgets
        ..add(Container(
          margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 17.0),
          child: Image(
            image: AssetImage("assets/images/google-logo.png"),
            height: 35.0,
          ),
        ))
        ..add(Container(
          child: Text(
            "Continue With Google",
            style: TextStyle(fontSize: 17),
          ),
        ));
    }

    return widgets.toList();
  }
}
