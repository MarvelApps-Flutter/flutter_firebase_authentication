import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AppleSigninProvider extends ChangeNotifier
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  login() async{
    final AuthorizationResult result = await TheAppleSignIn.performRequests(
      [
        AppleIdRequest(requestedScopes: [Scope.email,Scope.fullName])
      ]
    );
    if(result.status == AuthorizationStatus.authorized)
    {
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(result.credential!.identityToken!),
        accessToken: String.fromCharCodes(result.credential!.authorizationCode!)
      );
      print("credential is $credential");
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
}