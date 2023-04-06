import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimation {
  static Widget discreteCircle(double size) =>
      LoadingAnimationWidget.discreteCircle(
        color: kcVeryDarkGreyTextColor,
        size: size,
        secondRingColor: kcSecondaryColor,
        thirdRingColor: kcWhiteColor,
      );

  static Widget fourRotatingDot(double size) =>
      LoadingAnimationWidget.fourRotatingDots(
        color: kcVeryDarkGreyTextColor,
        size: size,
      );

  static Widget twistingDot(double size) => LoadingAnimationWidget.twistingDots(
        leftDotColor: kcVeryDarkGreyTextColor,
        rightDotColor: kcSecondaryColor,
        size: size,
      );
}
