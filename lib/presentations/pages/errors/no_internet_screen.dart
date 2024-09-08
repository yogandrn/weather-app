import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/core/configs/asset_const.dart';
import 'package:weather_app/presentations/themes/colors.dart';
import 'package:weather_app/presentations/themes/textstyles.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Oops!',
            style: headingStyle.copyWith(
              color: white,
            ),
          ),
          Text(
            'Koneksi internet terputus',
            style: textbodyStyle.copyWith(
              color: white,
              fontSize: 16,
            ),
          ),
          Lottie.asset(
            AssetConst.noInternetAnimation,
            height: screenHeight / 3,
          ),
        ],
      ),
    );
  }
}
