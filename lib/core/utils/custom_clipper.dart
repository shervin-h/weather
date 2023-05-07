import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    Path path = Path();
    path.lineTo(0 , height * 0.9);

    path.quadraticBezierTo(width * 0.25, height, width * 0.52, height * 0.9);
    path.quadraticBezierTo(width * 0.70, height * 0.9, width * 0.85, height * 0.95);
    path.quadraticBezierTo(width * 0.9, height * 0.97, width, height);

    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class CurveClipper2 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    Path path = Path();
    path.lineTo(0 , height);

    path.quadraticBezierTo(width * 0.25, height * 0.9, width * 0.5, height);
    path.quadraticBezierTo(width * 0.75, height * 0.9, width, height);

    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class CurveClipper3 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    Path path = Path();
    path.lineTo(0 , height * 0.92);

    path.quadraticBezierTo(width * 0.2, height, width * 0.4, height * 0.9);
    path.quadraticBezierTo(width * 0.6, height * 0.82, width * 0.8, height * 0.88);
    path.quadraticBezierTo(width * 0.9, height * 0.90, width, height * 0.90);

    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class CurveClipper4 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    Path path = Path();
    path.lineTo(0 , height);

    path.quadraticBezierTo(width * 0.20, height * 0.85, width * 0.40, height * 0.92);
    path.quadraticBezierTo(width * 0.50, height * 0.95, width * 0.60, height * 0.89);
    path.quadraticBezierTo(width * 0.70, height * 0.83, width * 0.80, height * 0.9);
    path.quadraticBezierTo(width * 0.9, height * 0.97, width, height);

    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}