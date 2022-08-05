import 'dart:io';

import 'package:email_login_app/constants/app_constants.dart';
import 'package:email_login_app/screens/splash_screen.dart';
import 'firebase_option.dart';
import 'screens/home_screen.dart';
import 'package:email_login_app/providers/facebook_signin_provider.dart';
import 'package:email_login_app/providers/google_signin_provider.dart';
import 'package:email_login_app/screens/login_screen.dart';
import 'package:email_login_app/share/easy_loading.dart';
import 'package:email_login_app/utils/store_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  await StoreDetails.init();
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        title: AppConstants.appTitleString,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       // home: user != null || isLinkedInLoggedIn == true || isFacebookLoggedIn == true ? const HomeScreen(): const LoginScreen(),
        
         home: const SplashScreen(),
      
        builder: EasyLoading.init(),
      ),
    );
  }
}

