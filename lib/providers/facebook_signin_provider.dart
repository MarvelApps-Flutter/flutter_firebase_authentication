import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInProvider extends ChangeNotifier
{
  Map<String, dynamic>? userData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  login() async {
    var result = await FacebookAuth.instance.login(
      permissions: ["public_profile", "email"],
    );

    // check the status of our login
    if (result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.instance.getUserData(
        fields: "email, name, picture",
      );

      userData = requestData;
      String email = userData?['email'];
      print("email as $email");

      notifyListeners();
      return userData;
    }
    else {
      print(result.message);
    }
  }

  // logout
  logout() async {
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
    userData = null;
    notifyListeners();
  }
}