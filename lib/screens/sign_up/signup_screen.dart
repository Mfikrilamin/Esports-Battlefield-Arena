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
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("SignUpView page is being built");
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: const [
                        BoxText.headingOne('Create Account'),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  const EmailInputField(),
                  UIHelper.verticalSpaceSmall(),
                  const PasswordInputField(),
                  UIHelper.verticalSpaceSmall(),
                  const CountryInputField(),
                  UIHelper.verticalSpaceSmall(),
                  const AddressInputField(),
                  UIHelper.verticalSpaceSmall(),
                  const UserTypeInputField(),
                ],
              ),
              UIHelper.verticalSpaceLarge(),
              !model.isBusy
                  ? BoxButton(
                      leading: const Icon(Icons.arrow_forward),
                      title: 'Next',
                      onTap: () {
                        model.navigateToSignInNextPage();
                      },
                    )
                  : const BoxButton(
                      title: 'Next',
                      busy: true,
                    ),
              UIHelper.verticalSpaceMedium(),
              BoxButton.outline(
                selected: false,
                // leading: Icon(Icons.arrow_back),
                title: 'Sign In',
                onTap: () {
                  model.navigateToSignInPage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailInputField extends StackedHookView<SignUpViewModel> {
  const EmailInputField({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    print('EmailInputField is being built');
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Email'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: 'Enter Email',
          onChanged: model.updateEmail,
          readOnly: false,
          errorText: model.isEmailValid ? null : 'Invalid Email',
        ),
      ],
    );
  }
}

class PasswordInputField extends StackedHookView<SignUpViewModel> {
  const PasswordInputField({Key? key}) : super(key: key, reactive: false);

  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    print('PasswordInputField is being built');
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Password'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          password: true,
          placeholder: 'Enter Password',
          onChanged: model.updatePassword,
          readOnly: false,
        ),
      ],
    );
  }
}

class AddressInputField extends StackedHookView<SignUpViewModel> {
  const AddressInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    print('AddressInputField is being built');
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Address'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: 'Enter Your Address',
          onChanged: model.updateAddress,
          readOnly: false,
        ),
      ],
    );
  }
}

class CountryInputField extends StackedHookView<SignUpViewModel> {
  const CountryInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    print('CountryInputField is being built');
    var text = useTextEditingController(text: model.country);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Country'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: false,
          onTap: () {
            showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  // text.text = value.name;
                  model.updateCountry(country.name, country.countryCode);
                  text.text = model.country;
                });
          },
          // traillingTapped: () {
          //   showCountryPicker(context: context, onSelect: (Country value) {});
          // },
          trailing: const Icon(
            Icons.location_on,
            color: kcMediumGreyColor,
          ),
          controller: text,
          placeholder: 'Select Your Country',
          onChanged: model.updateAddress,
        ),
      ],
    );
  }
}

class UserTypeInputField extends StackedHookView<SignUpViewModel> {
  const UserTypeInputField({Key? key}) : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, SignUpViewModel model) {
    print('UserTypeInputField is being built');
    // var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('User Type'),
        UIHelper.verticalSpaceSmall(),
        Row(
          children: [
            Expanded(
              child: BoxButton.outline(
                title: 'Player',
                onTap: () {
                  model.updateIsPlayer(true);
                },
                selected: model.isPlayer,
              ),
            ),
            UIHelper.horizontalSpaceSmall(),
            Expanded(
              child: BoxButton.outline(
                title: 'Organizer',
                onTap: () {
                  model.updateIsPlayer(false);
                },
                selected: !model.isPlayer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
