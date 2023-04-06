import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/styles.dart';
import 'package:flutter/material.dart';

class BoxText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const BoxText.headingOne(this.text, {Key? key})
      : style = headingStyle1,
        super(key: key);
  const BoxText.headingTwo(this.text, {Key? key})
      : style = headingStyle2,
        super(key: key);
  const BoxText.headingThree(this.text, {Key? key})
      : style = headingStyle3,
        super(key: key);
  const BoxText.headline(this.text, {Key? key})
      : style = headlineStyle,
        super(key: key);
  const BoxText.subheading(this.text, {Key? key})
      : style = subHeadingStyle,
        super(key: key);
  const BoxText.caption(this.text, {Key? key})
      : style = captionStyle,
        super(key: key);

  BoxText.appBar(this.text, {Key? key, Color color = kcMediumGreyColor})
      : style = appBarStyle.copyWith(color: color),
        super(key: key);

  BoxText.body(this.text, {Key? key, Color color = kcMediumGreyColor})
      : style = bodyStyle.copyWith(color: color),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
