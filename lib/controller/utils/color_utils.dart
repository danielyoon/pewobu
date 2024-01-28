import 'package:flutter/material.dart';
import 'package:todo_list/ui/constants.dart';

class ColorUtils {
  static Color getColorFromIndex(int index) {
    switch (index) {
      case 0:
        return kPersonal;
      case 1:
        return kWork;
      case 2:
        return kGrey;
      default:
        return kGrey;
    }
  }
}
