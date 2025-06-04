import 'package:flutter/material.dart';

class Length {
  final BuildContext context;
  final String input;
  final double bottomNavHeight = 125.0;
  //

  late final double screenWidth;
  late final double screenHeight;

  Length({required this.context, required this.input}) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  double width() {
    switch (input) {
      case 'calendar':
        return _calendarWidth();
      case 'box':
        return _box();
      default:
        return screenWidth;
    }
  }

  double height() {
    switch (input) {
      case 'calendar':
        return _calendarHeight();
      case 'box':
        return _box();
      default:
        return screenHeight;
    }
  }

  double _box() {
    return screenWidth < screenHeight ? screenWidth : screenHeight;
  }

  double _calendarWidth() {
    if (screenWidth < 351) return screenWidth * 1;
    if (screenWidth < 401) return screenWidth * 0.82; // iPhone SE
    if (screenWidth < 501) return screenWidth * 0.85; // iPhone 6/7/8
    if (screenWidth < 601) return screenWidth * 0.85; // iPhone XR, 11
    if (screenWidth < 701) return screenWidth * 0.85;
    if (screenWidth < 801) return screenWidth * 0.55; // small tablets
    if (screenWidth < 901) return screenWidth * 0.55; // small tablets
    if (screenWidth < 1101) return screenWidth * 0.6; // tablets
    if (screenWidth < 1251) return screenWidth * 0.7;
    if (screenWidth < 1501) return screenWidth * 0.65; // laptops
    return screenWidth * 0.6; // desktop
  }

  double _calendarHeight() {
    if (screenHeight < 351) return screenHeight * 0.4;
    if (screenHeight < 401) return screenHeight * 0.45;
    if (screenHeight < 601) return screenHeight * 0.51;
    if (screenHeight < 701) return screenHeight * 0.52;
    if (screenHeight < 801) return screenHeight * 0.46;
    if (screenHeight < 901) return screenHeight * 0.45;
    if (screenHeight < 1001) return screenHeight * 0.45;
    if (screenHeight < 1101) return screenHeight * 0.47;
    if (screenHeight < 1251) return screenHeight * 0.45;
    if (screenHeight < 1501) return screenHeight * 0.5;
    return screenHeight * 0.6;
  }
}
