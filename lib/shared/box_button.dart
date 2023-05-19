import 'package:esports_battlefield_arena/components/animation/third_party_module/loading_animation.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/styles.dart';
import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool disable;
  final bool busy;
  final Widget? leading;
  final bool outline;
  final void Function()? onTap;
  final bool? selected;
  final double height;
  final double width;
  final double? textSize;

  const BoxButton({
    Key? key,
    required this.title,
    this.disable = false,
    this.busy = false,
    this.leading,
    this.outline = false,
    this.onTap,
    this.selected,
    this.height = 48,
    this.width = double.infinity,
    this.textSize,
  }) : super(key: key);

  const BoxButton.outline({
    Key? key,
    required this.title,
    this.onTap,
    this.leading,
    this.selected,
    this.height = 48,
    this.width = double.infinity,
    this.textSize,
  })  : disable = false,
        busy = false,
        outline = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          // duration: const Duration(milliseconds: 350),
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: !outline
              ? BoxDecoration(
                  color: !disable ? kcPrimaryColor : kcMediumGreyColor,
                  borderRadius: BorderRadius.circular(50),
                )
              : selected == true
                  ? BoxDecoration(
                      color: kcPrimaryDarkerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: kcPrimaryDarkerColor, width: 1),
                    )
                  : selected == false
                      ? BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: kcLightGreyColor, width: 1),
                        )
                      : BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: kcPrimaryDarkerColor, width: 1),
                        ),
          child: !busy
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null) leading!,
                    if (leading != null) const SizedBox(width: 5),
                    Text(title,
                        style: bodyStyle.copyWith(
                          fontWeight: !outline
                              ? FontWeight.bold
                              : (selected != null)
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          // ? FontWeight.w600
                          // : FontWeight.w400,
                          color: !outline
                              ? !disable
                                  ? kcVeryDarkGreyTextColor
                                  : kcLightGreyColor
                              : kcDarkGreyColor,
                          fontSize: textSize ?? 16,
                        )),
                  ],
                )
              : Stack(children: [
                  Center(
                    child: LoadingAnimation.twistingDot(30),
                  ),
                ])
          // : const CircularProgressIndicator(
          //     color: kcVeryDarkGreyTextColor,
          //     strokeWidth: 5,
          //   ),
          ),
    );
  }
}
