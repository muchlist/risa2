class SliderHelper {
  const SliderHelper();

  String getLabelStatus(double number) {
    switch (number.toInt()) {
      case 1:
        return "Progress";
      case 2:
        return "Pending";
      case 3:
        return "Completed-with-Note";
      case 4:
        return "Completed";
      default:
        return "Unknown";
    }
  }

  int getStatus(double number) {
    switch (number.toInt()) {
      case 1:
        return 1;
      case 2:
        return 3;
      case 3:
        return 6;
      case 4:
        return 4;
      default:
        return 1;
    }
  }

  double getSliderNum(int status) {
    switch (status) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 2;
      case 4:
        return 4;
      case 5:
        return 3;
      case 6:
        return 3;
      default:
        return 1;
    }
  }
}
