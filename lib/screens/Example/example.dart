import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:flutter/material.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        children: [
          const BoxText.headingOne('Design System'),
          UIHelper.verticalSpaceSmall(),
          const Divider(),
          UIHelper.verticalSpaceSmall(),
          ...buttonWidgets,
          ...textWidgets,
          ...inputFields,
        ],
      ),
    );
  }

  List<Widget> get textWidgets => [
        const BoxText.headline('Text Styles'),
        UIHelper.verticalSpaceMedium(),
        const BoxText.headingOne('Heading One'),
        UIHelper.verticalSpaceMedium(),
        const BoxText.headingTwo('Heading Two'),
        UIHelper.verticalSpaceMedium(),
        const BoxText.headingThree('Heading Three'),
        UIHelper.verticalSpaceMedium(),
        const BoxText.headline('Headline'),
        UIHelper.verticalSpaceMedium(),
        const BoxText.subheading('This will be a sub heading to the headling'),
        UIHelper.verticalSpaceMedium(),
        BoxText.body('Body Text that will be used for the general body'),
        UIHelper.verticalSpaceMedium(),
        const BoxText.caption(
            'This will be the caption usually for smaller details'),
        UIHelper.verticalSpaceMedium(),
      ];

  List<Widget> get buttonWidgets => [
        const BoxText.headline('Buttons'),
        UIHelper.verticalSpaceMedium(),
        BoxText.body('Normal'),
        UIHelper.verticalSpaceSmall(),
        const BoxButton(
          title: 'SIGN IN',
        ),
        UIHelper.verticalSpaceSmall(),
        BoxText.body('Disabled'),
        UIHelper.verticalSpaceSmall(),
        const BoxButton(
          title: 'SIGN IN',
          disable: true,
        ),
        UIHelper.verticalSpaceSmall(),
        BoxText.body('Busy'),
        UIHelper.verticalSpaceSmall(),
        const BoxButton(
          title: 'SIGN IN',
          busy: true,
        ),
        UIHelper.verticalSpaceSmall(),
        BoxText.body('Outline'),
        UIHelper.verticalSpaceSmall(),
        const BoxButton.outline(
          title: 'Select location',
          leading: Icon(
            Icons.send,
            color: kcPrimaryDarkerColor,
          ),
        ),
        UIHelper.verticalSpaceMedium(),
      ];

  List<Widget> get inputFields => [
        const BoxText.headline('Input Field'),
        UIHelper.verticalSpaceSmall(),
        BoxText.body('Normal'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: false,
          controller: TextEditingController(),
          placeholder: 'Enter Password',
        ),
        UIHelper.verticalSpaceSmall(),
        BoxText.body('Leading Icon'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: false,
          controller: TextEditingController(),
          leading: const Icon(
            Icons.reset_tv,
            color: kcSecondaryMediumColor,
          ),
          placeholder: 'Enter TV Code',
        ),
        UIHelper.verticalSpaceSmall(),
        BoxText.body('Trailing Icon'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: false,
          controller: TextEditingController(),
          trailing:
              const Icon(Icons.clear_outlined, color: kcSecondaryMediumColor),
          placeholder: 'Search for things',
        ),
      ];
}
