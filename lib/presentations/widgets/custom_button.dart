// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import '../../presentations/themes/colors.dart';
import '../../presentations/themes/textstyles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() action;
  final IconData? icon;
  final Color? backgroundColor, textColor;
  final double textSize, borderRadius;
  final double? width, height, iconSize;
  final EdgeInsets? margin;
  const CustomButton({
    super.key,
    required this.text,
    required this.action,
    this.backgroundColor,
    this.textColor,
    this.textSize = 16,
    this.borderRadius = 12,
    this.height,
    this.width,
    this.iconSize,
    this.margin,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        margin: margin ?? EdgeInsets.all(0),
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: backgroundColor ?? primary,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ]),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: textButtonStyle.copyWith(
                      color: textColor ?? white,
                      fontSize: textSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    icon,
                    size: iconSize,
                    color: textColor ?? white,
                  ),
                ],
              )
            : Text(
                text,
                style: textButtonStyle.copyWith(
                  color: textColor ?? white,
                  fontSize: textSize,
                ),
              ),
      ),
      onPressed: action,
    );
  }
}
