import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

Future<FirebaseUser> signInFirebaseWithGoogle(GoogleSignIn googleSignIn) async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signIn();
  }

  GoogleSignInAuthentication googleAuth = await user.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    idToken: googleAuth.idToken,
    accessToken: googleAuth.accessToken,
  );
  final AuthResult response =
      await FirebaseAuth.instance.signInWithCredential(credential);
  final FirebaseUser currentUser = response.user;

  return currentUser;
}
