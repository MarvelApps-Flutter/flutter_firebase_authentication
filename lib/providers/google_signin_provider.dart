import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn){
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async{
    isSigningIn = true;
    final user = await googleSignIn.signIn();
    print("user info");
    print(user);
    if(user == null)
    {
      isSigningIn = false;
      return;
    }
    else{

      final googleAuth = await user.authentication;
      print("googleAuth info");
      print(googleAuth);
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      isSigningIn = false;
      return user;
    }
  }

  Future<void> logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}