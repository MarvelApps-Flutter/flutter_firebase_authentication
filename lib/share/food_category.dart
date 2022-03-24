import 'package:email_login_app/utils/app_config.dart';
import 'package:email_login_app/utils/app_text_styles.dart';
import 'package:email_login_app/utils/star_display.dart';
import 'package:flutter/material.dart';

class FoodCategory extends StatefulWidget {
  final String? id;
  final String? name;
  final String? category;
  final String? imagePath;
  final double? price;
  final double? discount;
  final double? ratings;

  @override
  _FoodCategoryState createState() => _FoodCategoryState();

  const FoodCategory(
      {Key? key, this.id,
      this.name,
      this.category,
      this.imagePath,
      this.discount,
      this.price,
      this.ratings}) : super(key: key);
}

class _FoodCategoryState extends State<FoodCategory> {
  late AppConfig appC;
  @override
  Widget build(BuildContext context) {
    appC = AppConfig(context);
    return buildBody();
  }

  Widget buildBody()
  {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: [
          Container(
            height: appC.rH(26),
            width: appC.rW(92),
            child: Image.asset(
              widget.imagePath!,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              height: 60.0,
              width: 340.0,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black12,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
            ),
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            right: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name!,
                      style: AppTextStyles.boldWhiteTextStyle,
                    ),
                    const IconTheme(
                      data: IconThemeData(
                        size: 20,
                      ),
                      child: StarDisplay(value: 4),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "${widget.price}",
                      style: AppTextStyles.boldWhiteTextStyle,
                    ),
                    const Text(
                      "Min Order",
                      style: AppTextStyles.mediumWhiteTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
