import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_login_app/constants/app_constants.dart';
import 'package:email_login_app/data/food_data.dart';
import 'package:email_login_app/models/food_model.dart';
import 'package:email_login_app/providers/facebook_signin_provider.dart';
import 'package:email_login_app/screens/login_screen.dart';
import 'package:email_login_app/share/food_category.dart';
import 'package:email_login_app/share/reusable_widgets.dart';
import 'package:email_login_app/utils/app_text_styles.dart';
import 'package:email_login_app/utils/store_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String>? imgList;
  int? pageIndex;
  List<Widget>? imageSliders;
  List<FoodModel>? _foods;
  bool? isLinkedInLoggedIn;
  bool? isFacebookLoggedIn;

  void init() {
    isLinkedInLoggedIn = StoreDetails.checkLinkedInLoginSession(
        StoreDetails.isUserLinkedInLoggedIn);
    isFacebookLoggedIn = StoreDetails.checkFacebookLoginSession(
        StoreDetails.isUserFacebookLoggedIn);
    pageIndex = 0;
    imageSliders = [];
    _foods = foods;
    imgList = [
      AppConstants.firstAssetImageString,
      AppConstants.secondAssetImageString,
      AppConstants.thirdAssetImageString,
      AppConstants.fourthAssetImageString,
    ];
    imageSliders = imgList!
        .map((item) => Container(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.cover, width: 400.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          buildSizedBoxWidget(10),
          CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders),
          buildSizedBoxWidget(10),
          buildSizedBoxWidget(8),
          foodCategoryHeading(),
          buildSizedBoxWidget(20),
          Column(
            children: _foods!.map(buildFoodCategory).toList(),
          )
        ],
      )),
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Center(
        child: Text(
          AppConstants.homeString,
          style: AppTextStyles.mediumBlackTextStyle,
        ),
      ),
      leading: IconButton(
        padding: const EdgeInsets.only(left: 10),
        onPressed: () {},
        icon: const Icon(Icons.menu),
        iconSize: 24,
        color: Colors.black,
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 15),
          onPressed: () {},
          icon: Icon(Icons.search),
          iconSize: 24,
          color: Colors.black,
        ),
        IconButton(
          padding: const EdgeInsets.only(right: 15),
          onPressed: () {
            if (FirebaseAuth.instance.currentUser != null) {
              FirebaseAuth.instance.signOut().then((value) {
                print(AppConstants.signedOutString);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              });
            }
            if (isLinkedInLoggedIn == true) {
              setState(() {
                StoreDetails.callLinkedInLogout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              });
            }
            if (isFacebookLoggedIn == true) {
              Provider.of<FacebookSignInProvider>(context, listen: false)
                  .logout();
              setState(() {
                StoreDetails.callFacebookLogout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              });
            }
          },
          icon: const Icon(Icons.logout),
          iconSize: 24,
          color: Colors.black,
        )
      ],
    );
  }

  Widget foodCategoryHeading() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              AppConstants.foodCategoryString,
              style: AppTextStyles.boldTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Text(
              AppConstants.viewAllString,
              style: AppTextStyles.mediumTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Container buildBottomNavBar(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Color(0xFF7061fa),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home_filled,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 25,
              )),
        ],
      ),
    );
  }

  Widget buildFoodCategory(FoodModel food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: FoodCategory(
          imagePath: food.imagePath,
          id: food.id,
          name: food.name,
          price: food.price),
    );
  }
}
