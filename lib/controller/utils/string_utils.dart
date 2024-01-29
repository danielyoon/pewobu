class StringUtils {
  static String getTitleFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Personal';
      case 1:
        return 'Work';
      case 2:
        return 'Bucket';
      default:
        return 'Personal';
    }
  }
}
