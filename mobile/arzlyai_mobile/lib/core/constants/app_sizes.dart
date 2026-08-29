import 'package:flutter/material.dart';

extension AppSizes on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  double get referenceSize =>
      screenWidth < screenHeight ? screenWidth : screenHeight;

  double get bottomPadding =>
      viewPadding.bottom > 0 ? viewPadding.bottom : paddingMedium;

  double get keyboardBottomInset => viewInsets.bottom;
  double get topPadding =>
      viewPadding.top > 0 ? viewPadding.top : paddingMedium;

  double get paddingSmall => screenWidth * 0.02;
  double get paddingMedium => screenWidth * 0.04;
  double get paddingLarge => screenWidth * 0.06;
  double get paddingExtraLarge => screenWidth * 0.1;

  double get spaceSmall => screenHeight * 0.01;
  double get spaceMedium => screenHeight * 0.02;
  double get spaceLarge => screenHeight * 0.04;
  double get spaceExtraLarge => screenHeight * 0.08;

  double get borderRadiusSmall => referenceSize * 0.03;
  double get borderRadiusMedium => referenceSize * 0.03;
  double get borderRadiusLarge => referenceSize * 0.06;

  double get iconSmall => referenceSize * 0.035;
  double get iconMedium => referenceSize * 0.05;
  double get iconLarge => referenceSize * 0.055;

  double get loadingIndicatorSmall => referenceSize * 0.045;
  double get loadingIndicatorMedium => referenceSize * 0.09;
  double get loadingStrokeWidth => referenceSize * 0.005;
  double get loadingStrokeWidthBold => referenceSize * 0.006;

  EdgeInsets get tilePadding => EdgeInsets.symmetric(
    horizontal: paddingSmall * 1.5,
    vertical: paddingSmall * 1.25,
  );

  double get workflowNodeHeight => referenceSize * 0.19;
  double get workflowVerticalGap => referenceSize * 0.1;
  double get workflowPortRadius => referenceSize * 0.0125;
  double get workflowGridSpacing => referenceSize * 0.06;
  double get workflowNodeIconBox => referenceSize * 0.1;

  double get borderWidthThin => 1;
  double get borderWidthMedium => 1.5;
  double get borderWidthThick => 2.5;

  double get glowBlurSmall => referenceSize * 0.02;
  double get glowBlurMedium => referenceSize * 0.04;
  double get glowBlurLarge => referenceSize * 0.08;
  double get glowSpreadSmall => referenceSize * 0.0075;
  double get glowSpreadMedium => referenceSize * 0.0125;
  double get glowSpreadLarge => referenceSize * 0.02;
  Offset get shadowOffsetSmall => Offset(0, referenceSize * 0.0075);

  double get mainBottomNavHeight => screenHeight * 0.14;

  double get scrollPaddingAboveMainNav => mainBottomNavHeight + spaceMedium;
}
