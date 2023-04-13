import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
import 'package:esports_battlefield_arena/screens/sign_up/signup_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class SignUpNextView extends StatelessWidget {
  const SignUpNextView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("SignUpNextView page is being built");
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                BoxText.headingOne('Finishing Up The'),
                                BoxText.headingOne('Account'),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceMedium(),
                          !model.isPlayer
                              ? Column(
                                  children: [
                                    const OrganizerNameInputField(),
                                    UIHelper.verticalSpaceSmall(),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const FirstNameInputField(),
                                    UIHelper.verticalSpaceSmall(),
                                    const LastNameInputField(),
                                    UIHelper.verticalSpaceSmall(),
                                  ],
                                ),
                          UIHelper.verticalSpaceMediumLarge(),
                          !model.isBusy
                              ? BoxButton(
                                  title: 'Register',
                                  onTap: () {
                                    model.processSignUp();
                                  },
                                )
                              : const BoxButton(
                                  title: 'Register',
                                  busy: true,
                                ),
                          UIHelper.verticalSpaceMedium(),
                          BoxButton.outline(
                            selected: false,
                            // leading: Icon(Icons.arrow_back),
                            title: 'Go Back',
                            onTap: () {
                              model.navigatetoPreviousPage();
                            },
                          ),
                        ],
                      ),
                      model.isSignUpSucess
                          ? Positioned.fill(
                              child: Column(
                                children: const [
                                  Spacer(),
                                  SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: RiveAnimation.asset(
                                          "assets/RiveAssets/sucess_check.riv")),
                                  Spacer(),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FirstNameInputField extends StackedHookView<SignUpViewModel> {
  const FirstNameInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('First Name'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: 'Your First Name',
          readOnly: false,
          onChanged: model.updateFirstName,
        ),
      ],
    );
  }
}

class LastNameInputField extends StackedHookView<SignUpViewModel> {
  const LastNameInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Last Name'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          readOnly: false,
          placeholder: 'Your Last Name',
          onChanged: model.updateLastName,
        ),
      ],
    );
  }
}

class OrganizerNameInputField extends StackedHookView<SignUpViewModel> {
  const OrganizerNameInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Organization Name'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          readOnly: false,
          placeholder: 'Company/Club Name',
          onChanged: model.updateLastName,
        ),
      ],
    );
  }
}
