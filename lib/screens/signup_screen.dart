import 'package:email_login_app/constants/app_constants.dart';
import 'home_screen.dart';
import 'package:email_login_app/screens/login_screen.dart';
import 'package:email_login_app/share/reusable_widgets.dart';
import 'package:email_login_app/utils/app_config.dart';
import 'package:email_login_app/utils/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_login_app/mixins/validate_mixin.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with InputValidationMixin {
  var auth;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? formGlobalKey;
  bool? isUsernameErrorVisible;
  bool? isEmailErrorVisible;
  bool? isPasswordErrorVisible;
  late AppConfig _ac;

  init()
  {
    auth = FirebaseAuth.instance;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    formGlobalKey = GlobalKey<FormState>();
    isUsernameErrorVisible = false;
    isEmailErrorVisible = false;
    isPasswordErrorVisible = false;
  }

  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _ac = AppConfig(context);
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
                    height: _ac.rH(26),
                    width: _ac.rW(60),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppConstants.headersAssetImageString),
                        fit: BoxFit.fill,
                        //repeat:ImageRepeat.repeat,
                      ),
                    ),
                  ),
                  buildSizedBoxWidget(10),
                  const Text(AppConstants.signUpNowString, style: AppTextStyles.blackTextStyle),
                  buildSizedBoxWidget(13),
                  const Text(
                    AppConstants.enterDetailString,
                    style: AppTextStyles.lightTextStyle,
                  ),
                  buildSizedBoxWidget(15),
                  buildEmailTextField(),
                  buildSizedBoxWidget(10),
                  buildPasswordTextField(),
                  buildSizedBoxWidget(15),
                  buildButtonWidget(context, AppConstants.capitalSignUpString, () {
                    if (formGlobalKey!.currentState!.validate()) {
                      if (_emailController!.text.toString().trim().length != 0 &&
                          _passwordController!.text.toString().trim().length !=
                              0) {
                        Future.delayed(Duration(seconds: 4));
                        EasyLoading.show(status: AppConstants.pleaseWaitString);
                        auth
                            .createUserWithEmailAndPassword(
                                email: _emailController!.text,
                                password: _passwordController!.text)
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                          EasyLoading.showSuccess(AppConstants.registeredSuccessfullyString);
                          EasyLoading.dismiss();
                        }).onError((error, stackTrace) {
                          EasyLoading.showError(error.toString());
                          EasyLoading.dismiss();
                        });
                      }
                    }
                  }),
                  navigationTextWidget(context, AppConstants.alreadyHaveAnAccountString,
                      const LoginScreen(), AppConstants.smallLoginString),
                ],
              ),
            ),
          ),
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
        labelText: AppConstants.enterEmailString,
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
            return AppConstants.enterValidEmailString;
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
        labelText: AppConstants.enterPasswordString,
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
            return AppConstants.enterValidPasswordString;
          }
      },
    );
  }
}
