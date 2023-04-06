import 'package:country_picker/country_picker.dart';
import 'package:esports_battlefield_arena/screens/profile/profile_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: AppBar(
            backgroundColor: kcPrimaryColor,
            // backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            scrolledUnderElevation: 0,
            actions: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: GestureDetector(
                  onTap: () {
                    actionNavs.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      actionNavs.input!.change(false);
                      // model.navigateBasedOnBottomBar();
                    });
                  },
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: RiveAnimation.asset(
                      actionNavs.src,
                      fit: BoxFit.contain,
                      artboard: actionNavs.artBoard,
                      onInit: (artBoard) {
                        RiveUtils riveUtils = RiveUtils();
                        StateMachineController controller =
                            riveUtils.getRiveController(artBoard,
                                stateMachineName: actionNavs.stateMachineName);
                        actionNavs.input =
                            controller.findSMI("Hover") as SMIBool;
                      },
                    ),
                  ),
                ),
              ),
            ],
            // title: const Text('Profile'),
          ),
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  height: 80,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kcPrimaryColor,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BoxText.headingThree('Welcome Back,'),
                      UIHelper.verticalSpaceSmall(),
                      model.isPlayer
                          ? BoxText.subheading(
                              '${model.firstName} ${model.lastName}')
                          : BoxText.subheading(model.organization),
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
              ],
            ),
            UIHelper.verticalSpaceMediumLarge(),
            !model.isBusy
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: BoxButton(
                      title: 'Update',
                      onTap: () {
                        // model.navigateToSignInNextPage();
                      },
                    ),
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: const BoxButton(
                      title: 'Next',
                      busy: true,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

RiveAsset actionNavs = RiveAsset(
  'assets/RiveAssets/setting_icon.riv',
  artBoard: 'SETTINGS',
  stateMachineName: "SETTINGS_interactivity",
);

class EmailInputField extends StackedHookView<ProfileViewModel> {
  const EmailInputField({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, ProfileViewModel model) {
    print('EmailInputField is being built');
    var text = useTextEditingController(text: model.email);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
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
      ),
    );
  }
}

class PasswordInputField extends StackedHookView<ProfileViewModel> {
  const PasswordInputField({Key? key}) : super(key: key, reactive: false);

  @override
  Widget builder(BuildContext context, ProfileViewModel model) {
    print('PasswordInputField is being built');
    var text = useTextEditingController(text: model.password);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
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
      ),
    );
  }
}

class AddressInputField extends StackedHookView<ProfileViewModel> {
  const AddressInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, ProfileViewModel model) {
    print('AddressInputField is being built');
    var text = useTextEditingController(text: model.address);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
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
      ),
    );
  }
}

class CountryInputField extends StackedHookView<ProfileViewModel> {
  const CountryInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, ProfileViewModel model) {
    print('CountryInputField is being built');
    var text = useTextEditingController(text: model.country);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
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
      ),
    );
  }
}
