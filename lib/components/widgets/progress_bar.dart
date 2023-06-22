import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:flutter/material.dart';

class CurvedProgressBar extends StatelessWidget {
  final double progress;
  final Color fillColor;
  final Color backgroundColor;
  final double height;
  final String text;

  CurvedProgressBar({
    required this.progress,
    required this.fillColor,
    required this.backgroundColor,
    required this.height,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(color: kcPrimaryDarkerColor, width: 1),
              )
              // decoration: BoxDecoration(
              //   color: kcTertiaryColor,
              //   borderRadius: BorderRadius.circular(height / 2),
              // ),
              ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress / 100,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                      color: kcVeryDarkGreyTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          // Center(
          //   child: Text(
          //     text,
          //     style: TextStyle(
          //         color: kcVeryDarkGreyTextColor,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600),
          //   ),
          // )
        ],
      ),
    );
  }
}
