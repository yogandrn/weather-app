import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../themes/colors.dart';
import '../../themes/textstyles.dart';
import '../../widgets/custom_button.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primary,
                  white,
                ],
              ),
            ),
          ),

          Positioned(
            top: -64,
            right: -420,
            child: Image.asset(
              'assets/images/circular.png',
              height: size.height,
            ),
          ),

          Positioned(
            bottom: 72,
            right: -240,
            child: ImageIcon(
              const AssetImage('assets/images/cloud.png'),
              size: size.width * 1.35,
              color: white.withOpacity(0.64),
            ),
          ),

          Positioned(
              top: 128,
              left: -84,
              child: Container(
                height: size.width / 2.1,
                width: size.width / 2.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    gradient: LinearGradient(
                      colors: [
                        secondaryDark,
                        secondaryDark,
                        secondary,
                        secondaryLight,
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    )),
              )),

          // The Sun and circles (using Positioned for precise positioning)
          // Positioned(
          //   top: 100,
          //   left: 20,
          //   child: SunWithCircles(),
          // ),

          // The Cloud (using Positioned for precise positioning)
          // Positioned(
          //   bottom: 300,
          //   left: 30,
          //   child: CloudShape(),
          // ),

          // The Text and Button at the bottom
          Positioned(
            bottom: 128,
            left: 56,
            right: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Never get caught in the rain again',
                  textAlign: TextAlign.start,
                  style: headingStyle.copyWith(
                    color: black,
                    fontSize: 32,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Stay ahead of the weather with our accurate forecasts',
                  textAlign: TextAlign.start,
                  style: textbodyStyle.copyWith(color: darkGrey, fontSize: 15),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Get Started",
                  action: () => Navigator.pushNamed(context, '/weather'),
                  height: 56,
                  backgroundColor: white,
                  textColor: primaryDark,
                  icon: Icons.keyboard_arrow_right_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
