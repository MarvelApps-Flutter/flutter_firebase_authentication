import 'package:email_login_app/constants/app_constants.dart';
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
  var auth;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? formGlobalKey;
  bool? isEmailErrorVisible;
  bool? isPasswordErrorVisible;
  late AppConfig appC;
  String? redirectUrl;
  String? clientId;
  String? clientSecret;
  UserObject? user;

  init()
  {
    auth = FirebaseAuth.instance;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    formGlobalKey = GlobalKey<FormState>();
    isEmailErrorVisible = false;
    isPasswordErrorVisible = false;
    redirectUrl = AppConstants.redirectUrlString;
    clientId = AppConstants.clientIdString;
    clientSecret = AppConstants.clientSecretString;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
                        image: AssetImage(AppConstants.headerAssetImageString),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  buildSizedBoxWidget(10),
                  const Text(AppConstants.loginNowString, style: AppTextStyles.blackTextStyle),
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
                  buildButtonWidget(context, AppConstants.capitalLoginString, () {
                    if (formGlobalKey!.currentState!.validate()) {
                      if (_emailController!.text.toString().trim().length != 0 &&
                          _passwordController!.text.toString().trim().length !=
                              0) {
                        Future.delayed(Duration(seconds: 4));
                        EasyLoading.show(status: AppConstants.pleaseWaitString);
                        auth
                            .signInWithEmailAndPassword(
                                email: _emailController!.text,
                                password: _passwordController!.text)
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                          EasyLoading.showSuccess(AppConstants.loginSuccessfullyString);
                          EasyLoading.dismiss();
                        }).onError((error, stackTrace) {
                          Future.delayed(Duration(seconds: 2));
                          EasyLoading.showError(AppConstants.userDoesNotExistString);
                          EasyLoading.dismiss();
                        });
                      }
                    }
                  }),
                  _buildSignInWithText(),
                  navigationTextWidget(context, AppConstants.dontHaveAccountString,
                      SignUpScreen(), AppConstants.registerString),
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
          const Text(AppConstants.orString, style: AppTextStyles.lightTextStyle),
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
          AppConstants.continueWithSocialMediaString,
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
              AppConstants.facebookAssetImageString,
            ),
          ),
          _buildSocialBtn(
            () async {
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .login()
                  .then((value) {

                if (value != null) {
                  EasyLoading.showSuccess(AppConstants.loggedInSuccessfully);
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
              AppConstants.googleAssetImageString,
            ),
          ),
          _buildSocialBtn(
            () {

              buildLinkedInlogin();
            },
            const AssetImage(
              AppConstants.linkedInAssetImageString,
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
            title: const Text(AppConstants.linkedInLogin),
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

          },
          onGetUserProfile: (UserSucceededAction linkedInUser) {

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
      onTap: () {},
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: AppConstants.dontHaveAccountAnString,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: AppConstants.signUpString,
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
