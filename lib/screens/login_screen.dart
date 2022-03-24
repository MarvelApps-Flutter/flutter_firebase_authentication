import 'dart:ui';
import 'home_screen.dart';
import 'package:email_login_app/mixins/validate_mixin.dart';
import 'package:email_login_app/models/user_object.dart';
import 'package:email_login_app/providers/facebook_signin_provider.dart';
import 'package:email_login_app/providers/google_signin_provider.dart';
import 'package:email_login_app/screens/signup_screen.dart';
import 'package:email_login_app/share/reusable_widgets.dart';
import 'package:email_login_app/utils/app_config.dart';
import 'package:email_login_app/utils/app_text_styles.dart';
import 'package:email_login_app/utils/store_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool isEmailErrorVisible = false;
  bool isPasswordErrorVisible = false;
  late AppConfig appC;
  String redirectUrl = 'https://www.youtube.com/callback';
  String clientId = '86n7nmswa9d9mu';
  String clientSecret = 'cFH2ZE9qEZw87Qvw';
  UserObject? user;
  @override
  Widget build(BuildContext context) {
    appC = AppConfig(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: appC.rH(26),
                    width: appC.rW(60),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/headers.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  buildSizedBoxWidget(10),
                  const Text("Login Now", style: AppTextStyles.blackTextStyle),
                  buildSizedBoxWidget(13),
                  const Text(
                    "Please enter the details below to continue",
                    style: AppTextStyles.lightTextStyle,
                  ),
                  buildSizedBoxWidget(15),
                  buildEmailTextField(),
                  buildSizedBoxWidget(10),
                  buildPasswordTextField(),
                  buildSizedBoxWidget(15),
                  buildButtonWidget(context, "LOGIN", () {
                    if (formGlobalKey.currentState!.validate()) {
                      if (_emailController.text.toString().trim().length != 0 &&
                          _passwordController.text.toString().trim().length !=
                              0) {
                        Future.delayed(Duration(seconds: 4));
                        EasyLoading.show(status: 'Please Wait...');
                        auth
                            .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text)
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                          EasyLoading.showSuccess('Logged in Successfully...');
                          EasyLoading.dismiss();
                        }).onError((error, stackTrace) {
                          Future.delayed(Duration(seconds: 2));
                          EasyLoading.showError('User does not exist');
                          print("Error ${error.toString()}");
                          EasyLoading.dismiss();
                        });
                      }
                    }
                  }),
                  _buildSignInWithText(),
                  navigationTextWidget(context, "Don't have account?",
                      SignUpScreen(), "Register"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                )),
          ),
          const Text("or", style: AppTextStyles.lightTextStyle),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                )),
          ),
        ]),
        const SizedBox(height: 20.0),
        const Text(
          'Continue with Social Media',
          style: AppTextStyles.lightTextStyle,
        ),
        _buildSocialBtnRow(),
        _buildSignupBtn(),
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () {
              Provider.of<FacebookSignInProvider>(context, listen: false)
                  .login()
                  .then((value) {
                if (value != null) {
                  StoreDetails.createLinkedInLoginSession();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                }
              });
            },
            const AssetImage(
              'assets/images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () async {
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .login()
                  .then((value) {
                print("value is $value");
                if (value != null) {
                  EasyLoading.showSuccess('Logged in Successfully...');
                  EasyLoading.dismiss();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                }
              });
            },
            const AssetImage(
              'assets/images/google.png',
            ),
          ),
          _buildSocialBtn(
            () {
              print('Login with LinkedIn');
              buildLinkedInlogin();
            },
            const AssetImage(
              'assets/images/linkedIn.png',
            ),
          ),
        ],
      ),
    );
  }

  buildLinkedInlogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LinkedInUserWidget(
          appBar: AppBar(
            title: const Text('LinkedIn Login'),
          ),
          destroySession: false,
          redirectUrl: redirectUrl,
          clientId: clientId,
          clientSecret: clientSecret,
          projection: const [
            ProjectionParameters.id,
            ProjectionParameters.localizedFirstName,
            ProjectionParameters.localizedLastName,
            ProjectionParameters.firstName,
            ProjectionParameters.lastName,
            ProjectionParameters.profilePicture,
          ],
          onError: (UserFailedAction e) {
            print('Error: ${e.stackTrace.toString()}');
          },
          onGetUserProfile: (UserSucceededAction linkedInUser) {
            print('Access token ${linkedInUser.user.token.accessToken}');
            user = UserObject(
              firstName: linkedInUser.user.firstName!.localized!.label!,
              lastName: linkedInUser.user.lastName!.localized!.label!,
              email: linkedInUser
                  .user.email!.elements![0].handleDeep!.emailAddress!,
              profileImageUrl: linkedInUser.user.profilePicture != null
                  ? linkedInUser.user.profilePicture!.displayImageContent!
                      .elements![0].identifiers![0].identifier!
                  : "",
            );
            Future.delayed(Duration.zero, () {
              StoreDetails.createLinkedInLoginSession();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
        labelText: "Enter Email",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (email) {
        if (isEmailValid(email!))
          {
            return null;
          }
        else
          {
            return 'Enter a valid email address';
          }
      },
    );
  }

  Widget buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        labelText: "Enter Password",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (password) {
        if (isPasswordValid(password!))
          {
            return null;
          }

        else
          {
            return 'Enter a valid password';
          }

      },
    );
  }
}
