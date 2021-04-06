import 'package:flutter/material.dart';

// * Spacing helper

/// width 5
const Widget horizontalSpaceTiny = SizedBox(
  width: 5,
);

/// width 10
const Widget horizontalSpaceSmall = SizedBox(
  width: 10,
);

/// width 18
const Widget horizontalSpaceRegular = SizedBox(
  width: 18,
);

/// width 25
const Widget horizontalSpaceMedium = SizedBox(
  width: 25,
);

/// width 50
const Widget horizontalSpaceLarge = SizedBox(
  width: 50,
);

/// height 5
const Widget verticalSpaceTiny = SizedBox(
  height: 5,
);

/// height 10
const Widget verticalSpaceSmall = SizedBox(
  height: 10,
);

/// height 18
const Widget verticalSpaceRegular = SizedBox(
  height: 18,
);

/// height 25
const Widget verticalSpaceMedium = SizedBox(
  height: 25,
);

/// height 50
const Widget verticalSpaceLarge = SizedBox(
  height: 50,
);

// Screen Size Helpers

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
bool screenIsPortrait(BuildContext context) =>
    MediaQuery.of(context).orientation == Orientation.portrait;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;
double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;
