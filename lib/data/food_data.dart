import 'package:email_login_app/constants/app_constants.dart';
import 'package:email_login_app/models/food_model.dart';

final foods =[
  FoodModel(
    id:AppConstants.oneString,
    name: AppConstants.samosaString,
    imagePath: AppConstants.firstAssetImageString,
    price: 28.0
  ),
  FoodModel(
    id:AppConstants.twoString,
    name: AppConstants.vegRollString,
    imagePath: AppConstants.secondAssetImageString,
    price: 100.0
  ),
  FoodModel(
    id:AppConstants.threeString,
    name: AppConstants.paneerWrapString,
    imagePath: AppConstants.thirdAssetImageString,
    price: 120.0,
  ),
  FoodModel(
    id:AppConstants.fourthString,
    name: AppConstants.vegBurgerString,
    imagePath: AppConstants.fourthAssetImageString,
    price: 98.0
  ),
];