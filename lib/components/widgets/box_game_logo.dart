import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoxGameLogo extends StatelessWidget {
  final String src;
  final double width;
  final Color backgroundColor;

  const BoxGameLogo({
    Key? key,
    required this.src,
    required this.backgroundColor,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      src,
      fit: BoxFit.contain,
      width: width,
    );
  }
}

Widget buildGameLogo(String game, double width) {
  if (game == GameType.ApexLegend.name) {
    return BoxGameLogo(
      src: 'assets/images/Apex_Legends_logo.svg',
      width: width,
      backgroundColor: kcTertiaryColor,
    );
  } else if (game == GameType.Valorant.name) {
    return BoxGameLogo(
      src: 'assets/images/Valorant_logo.svg',
      width: width,
      backgroundColor: kcDarkBackgroundColor,
    );
  } else {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        color: kcDarkBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Text(
        'No Image',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
