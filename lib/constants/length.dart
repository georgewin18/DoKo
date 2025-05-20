import 'package:flutter/material.dart';

class Length {
  Length({required this.input, required this.context});
  final String input;
  final BuildContext context;

  double width() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double temp;
    double result = width;
    if (height < width) {
      temp = height;
      height = width;
      width = temp;
    }

    if (input == "calendar") {
      if (width > 400) {
        width *= 0.9;
      } else {
        width *= 1;
      }
      result = width;
    }
    return result;
  }

  double height() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double temp;
    double result = height;
    if (width < height) {
      temp = height;
      height = width;
      width = temp;
    }
    if (input == "calendar") {
      if (height > 680) {
        height *= 1.065;
      } else {
        height *= 1.065;
      }
      result = height;
    }
    return result;
  }
}
