import 'package:flutter/material.dart';

extension AppSizes on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  double get bottomPadding =>
      viewPadding.bottom > 0 ? viewPadding.bottom : 16.0;

  double get keyboardBottomInset => viewInsets.bottom;
  double get topPadding => viewPadding.top > 0 ? viewPadding.top : 16.0;

  // Dynamic Spacing Helpers
  double get paddingSmall => screenWidth * 0.02;
  double get paddingMedium => screenWidth * 0.04;
  double get paddingLarge => screenWidth * 0.06;
  double get paddingExtraLarge => screenWidth * 0.1;

  double get spaceSmall => screenHeight * 0.01;
  double get spaceMedium => screenHeight * 0.02;
  double get spaceLarge => screenHeight * 0.04;
  double get spaceExtraLarge => screenHeight * 0.08;

  double get borderRadiusMedium => 12.0;
  double get borderRadiusLarge => 24.0;

  double get mainBottomNavHeight => screenHeight * 0.14;

  double get scrollPaddingAboveMainNav => mainBottomNavHeight + spaceMedium;
}
