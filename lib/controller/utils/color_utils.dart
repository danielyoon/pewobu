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
        return kBucket;
      default:
        return kGrey;
    }
  }

  static Color getColorFromTitle(String title) {
    switch (title.toLowerCase()) {
      case 'personal':
        return kPersonal;
      case 'work':
        return kWork;
      case 'bucket':
        return kBucket;
      default:
        return kGrey;
    }
  }
}
