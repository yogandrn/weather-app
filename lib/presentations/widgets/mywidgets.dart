import 'dart:ui';

import 'package:flutter/material.dart';

class SunWithCircles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        // Background circles behind the sun
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: CircleWidget(
            radius: 130,
            borderWidth: 1.0,
            borderColor: Colors.white.withOpacity(0.3),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: CircleWidget(
            radius: 89,
            borderWidth: 1.0,
            borderColor: Colors.white.withOpacity(0.3),
          ),
        ),
        // The Sun itself
      ],
    );
  }
}

class CircleWidget extends StatelessWidget {
  final double radius;
  final Color? color;
  final double? borderWidth;
  final Color? borderColor;

  CircleWidget(
      {required this.radius, this.color, this.borderWidth, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        shape: BoxShape.circle,
        border: borderWidth != null
            ? Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth!,
              )
            : null,
      ),
    );
  }
}

class CloudShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      child: CustomPaint(
        painter: CloudPainter(),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path cloudPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.36)
      ..cubicTo(size.width * 0.2, size.height * 0.2, size.width * 0.6,
          size.height * 0.2, size.width * 0.6, size.height * 0.6)
      ..cubicTo(size.width * 0.6, size.height * 0.9, size.width * 0.9,
          size.height * 0.9, size.width * 0.9, size.height * 0.7)
      ..arcToPoint(Offset(size.width * 0.3, size.height * 0.7),
          radius: Radius.circular(60))
      ..close();

    canvas.drawPath(cloudPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
