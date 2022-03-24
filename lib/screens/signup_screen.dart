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
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool isUsernameErrorVisible = false;
  bool isEmailErrorVisible = false;
  bool isPasswordErrorVisible = false;
  late AppConfig _ac;
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
                        image: AssetImage("assets/images/headers.jpg"),
                        fit: BoxFit.fill,
                        //repeat:ImageRepeat.repeat,
                      ),
                    ),
                  ),
                  buildSizedBoxWidget(10),
                  const Text("Sign Up Now", style: AppTextStyles.blackTextStyle),
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
                  buildButtonWidget(context, "SIGN UP", () {
                    if (formGlobalKey.currentState!.validate()) {
                      if (_emailController.text.toString().trim().length != 0 &&
                          _passwordController.text.toString().trim().length !=
                              0) {
                        Future.delayed(Duration(seconds: 4));
                        EasyLoading.show(status: 'Please Wait...');
                        auth
                            .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text)
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                          EasyLoading.showSuccess('Registered Successfully...');
                          EasyLoading.dismiss();
                        }).onError((error, stackTrace) {
                          EasyLoading.showError(error.toString());
                          print("Error ${error.toString()}");
                          EasyLoading.dismiss();
                        });
                      }
                    }
                  }),
                  navigationTextWidget(context, "You already have an account!",
                      const LoginScreen(), "Login"),
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
