import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/core/configs/asset_const.dart';
import 'package:weather_app/presentations/themes/colors.dart';
import 'package:weather_app/presentations/themes/textstyles.dart';

class OnErrorWidget extends StatelessWidget {
  final String message;
  final double fontSize;
  final String lottieAsset;
  const OnErrorWidget({
    super.key,
    this.message = "Terjadi kesalahan saat memproses permintaan",
    this.fontSize = 15.6,
    this.lottieAsset = AssetConst.errorWentWrongAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: Center(
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
            Lottie.asset(
              lottieAsset,
              width: screenHeight / 3,
            ),
            const SizedBox(height: 12),
            Text(
              '$message',
              maxLines: 5,
              textAlign: TextAlign.center,
              style: textbodyStyle.copyWith(
                color: white,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
