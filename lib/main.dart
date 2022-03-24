import 'screens/home_screen.dart';
import 'package:email_login_app/providers/facebook_signin_provider.dart';
import 'package:email_login_app/providers/google_signin_provider.dart';
import 'package:email_login_app/screens/login_screen.dart';
import 'package:email_login_app/share/easy_loading.dart';
import 'package:email_login_app/utils/store_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await StoreDetails.init();
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    bool isLinkedInLoggedIn = StoreDetails.checkLinkedInLoginSession(StoreDetails.isUserLinkedInLoggedIn);
    bool isFacebookLoggedIn = StoreDetails.checkFacebookLoginSession(StoreDetails.isUserFacebookLoggedIn);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_)=>GoogleSignInProvider(),
            child: const LoginScreen()),
        ChangeNotifierProvider(
            create: (_)=>FacebookSignInProvider(),
            child: const LoginScreen()),
      ],
      child: MaterialApp(
        title: 'Flutter Authentication Module',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user != null || isLinkedInLoggedIn == true || isFacebookLoggedIn == true ? const HomeScreen(): const LoginScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

