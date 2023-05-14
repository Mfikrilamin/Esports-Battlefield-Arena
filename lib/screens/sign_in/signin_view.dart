import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/screens/sign_in/signin_viewmodel.dart';
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
class SignInView extends StatelessWidget {
  const SignInView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("SignInView page is being built");
    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () => SignInViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: const [
                            BoxText.headline('Esport Arena'),
                            BoxText.headline('Battelfield')
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceMedium(),
                      const EmailInputField(),
                      UIHelper.verticalSpaceMedium(),
                      const PasswordInputField(),
                      UIHelper.verticalSpaceMediumLarge(),
                      !model.isBusy
                          ? BoxButton(
                              title: 'SIGN IN',
                              onTap: () {
                                model.processSignIn();
                              },
                            )
                          : const BoxButton(
                              title: 'SIGN IN',
                              busy: true,
                            ),
                      UIHelper.verticalSpaceMedium(),
                      BoxButton(
                        title: 'REGISTER',
                        disable: true,
                        onTap: () {
                          model.navigateToSignUpPage();
                        },
                      ),
                    ],
                  ),
                ),
                model.isSignInSucess
                    ? Positioned.fill(
                        child: Column(
                          children: const [
                            Spacer(),
                            SizedBox(
                                height: 180,
                                width: 180,
                                child: RiveAnimation.asset(
                                    "assets/RiveAssets/sucess_check2.riv")),
                            Spacer(),
                          ],
                        ),
                      )
                    : Container(),
                model.hasError
                    ? Positioned.fill(
                        child: Column(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                model.clearErrorMessage();
                              },
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.check_circle,
                                          color: kcTertiaryColor,
                                        ),
                                        Text("Invalid email or password"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmailInputField extends StackedHookView<SignInViewModel> {
  const EmailInputField({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, SignInViewModel model) {
    var text = useTextEditingController();
    print('EmailInputField is being built');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Email'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: model.isBusy,
          controller: text,
          placeholder: 'Enter Email',
          errorText: model.emailValid ? null : 'Invalid Email',
          onChanged: model.updateEmail,
        ),
      ],
    );
  }
}

class PasswordInputField extends StackedHookView<SignInViewModel> {
  const PasswordInputField({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, SignInViewModel model) {
    var text = useTextEditingController();
    print('PasswordInputField is being built');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Password'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: model.isBusy ? true : false,
          controller: text,
          password: true,
          placeholder: 'Enter Password',
          onChanged: model.updatePassword,
        ),
      ],
    );
  }
}
