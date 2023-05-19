import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
import 'package:direct_select/direct_select.dart';
import 'package:esports_battlefield_arena/components/widgets/hero_widget.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/register_tournament/tournament_registration_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class TournamentRegistrationView extends StatelessWidget {
  final Tournament tournament;
  const TournamentRegistrationView({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TournamentRegistrationViewModel>.reactive(
      viewModelBuilder: () => TournamentRegistrationViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: kcPrimaryColor,
          foregroundColor: kcDarkBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Registration',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: kcWhiteColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadeInRight(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    color: kcWhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpaceMedium(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInRight(
                                    from: 60,
                                    child: BoxText.headingTwo(tournament.title),
                                  ),
                                  UIHelper.verticalSpaceSmall(),
                                  FadeInRight(
                                    from: 70,
                                    delay: const Duration(milliseconds: 200),
                                    child: BoxText.body(tournament.game),
                                  ),
                                ],
                              ),
                            ),
                            UIHelper.horizontalSpaceSmall(),
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FadeInRight(
                                    from: 60,
                                    child: const BoxText.headingThree(
                                      'MYR',
                                    ),
                                  ),
                                  FadeInRight(
                                    from: 60,
                                    child: BoxText.headingThree(
                                      '${tournament.prizePool}000',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceMedium(),
                        FadeInRight(
                          delay: const Duration(milliseconds: 200),
                          from: 60,
                          child: BoxText.caption(tournament.description),
                        ),
                        UIHelper.verticalSpaceMedium(),
                        FadeInRight(
                          delay: const Duration(milliseconds: 200),
                          from: 60,
                          child: Row(
                            children: [
                              const BoxText.headingFour('Fee: RM '),
                              BoxText.headingFour(
                                  tournament.entryFee.toString()),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceMediumLarge(),
                        const TeamInformation(),
                        UIHelper.verticalSpaceMediumLarge(),
                        FadeInRight(
                          from: 70,
                          delay: const Duration(milliseconds: 200),
                          child: const BoxText.headingThree('Participant(s)'),
                        ),
                        // UIHelper.verticalSpaceSmall(),
                        FadeInRight(
                          delay: const Duration(milliseconds: 500),
                          from: 60,
                          child: !model.isBusy
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: (tournament.game ==
                                          GameType.Valorant.name)
                                      ? 5
                                      : tournament.isSolo
                                          ? 1
                                          : 3,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        UIHelper.verticalSpaceMedium(),
                                        FadeInRight(
                                          from: 60,
                                          delay:
                                              const Duration(milliseconds: 500),
                                          child: BoxText.subheading(
                                              'Participant ${index + 1}'),
                                        ),
                                        UIHelper.verticalSpaceSmall(),
                                        EmailInputField(
                                          index,
                                          model.getEmailController[index],
                                          key: UniqueKey(),
                                        ),
                                        UIHelper.verticalSpaceSmall(),
                                        UsernameInputField(
                                          index,
                                          key: UniqueKey(),
                                        ),
                                        UIHelper.verticalSpaceSmall(),
                                        tournament.game ==
                                                GameType.Valorant.name
                                            ? ValorantTaglineInputField(
                                                index,
                                                key: UniqueKey(),
                                              )
                                            : tournament.game ==
                                                    GameType.ApexLegend.name
                                                ? ApexPlatformTypeInputField(
                                                    index,
                                                    key: UniqueKey(),
                                                  )
                                                : Container(),
                                        UIHelper.verticalSpaceSmall(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            BoxButton(
                                              textSize: 12,
                                              height: 30,
                                              width: 60,
                                              title: 'Verify',
                                              onTap: () {
                                                model.verifyPlayerUsername(
                                                    tournament.game,
                                                    index,
                                                    context);
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                HeroWidget(
                  tag: 'registerButton',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    color: kcWhiteColor,
                    child: BoxButton(
                      title: 'Pay Now',
                      onTap: () => {
                        model.registerTournament(
                            tournament.tournamentId,
                            context,
                            isSolo: tournament.isSolo,
                            (tournament.game == GameType.Valorant.name)
                                ? 5
                                : tournament.isSolo
                                    ? 1
                                    : 3),
                      },
                      busy: model.isBusy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeamInformation extends StatelessWidget {
  const TeamInformation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      delay: const Duration(milliseconds: 200),
      from: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BoxText.headingThree('Team Information'),
          UIHelper.verticalSpaceSmall(),
          FadeInRight(
            from: 60,
            delay: const Duration(milliseconds: 500),
            child: const TeamNameInputField(),
          ),
          UIHelper.verticalSpaceSmall(),
          FadeInRight(
            from: 60,
            delay: const Duration(milliseconds: 500),
            child: const CountryInputField(),
          ),
        ],
      ),
    );
  }
}

class EmailInputField extends StackedHookView<TournamentRegistrationViewModel> {
  final int index;
  final String? initialText;
  const EmailInputField(this.index, this.initialText, {Key? key})
      : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
    var text = useTextEditingController(text: initialText);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Email'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: index == 0,
          controller: text,
          placeholder: 'Enter Email',
          errorText: model.getIsEmailValid[index]
              ? model.getIsEmailAlreadyRegisted[index]
                  ? null
                  : 'No user is registered to the email'
              : 'Invalid Email',
          onChanged: (value) {
            model.updatePlayerEmail(value, index);
          },
        ),
      ],
    );
  }
}

class TeamNameInputField
    extends StackedHookView<TournamentRegistrationViewModel> {
  const TeamNameInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
    print('TeamNameInputField is being built');
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Team Name'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: 'Enter Team Name',
          onChanged: model.updateTeamName,
          readOnly: false,
        ),
      ],
    );
  }
}

class CountryInputField
    extends StackedHookView<TournamentRegistrationViewModel> {
  const CountryInputField({Key? key}) : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
    print('CountryInputField is being built');
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Team country'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          readOnly: false,
          onTap: () {
            showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  text.text = country.name;
                  model.updateTeamCountry(country.name, country.countryCode);
                });
          },
          trailing: const Icon(
            Icons.location_on,
            color: kcPrimaryDarkerColor,
          ),
          controller: text,
          placeholder: 'Select Team Country',
          // onChanged: model.updateAddress,
        ),
      ],
    );
  }
}

class UsernameInputField
    extends StackedHookView<TournamentRegistrationViewModel> {
  final int index;
  const UsernameInputField(this.index, {Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Username'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: 'Enter your game username',
          trailing: model.getIsUsernameValid[index]
              ? const Icon(
                  Icons.done,
                  color: Colors.green,
                )
              : null,
          onChanged: (username) {
            model.updateUsername(username, index);
          },
          readOnly: false,
        ),
      ],
    );
  }
}

class ValorantTaglineInputField
    extends StackedHookView<TournamentRegistrationViewModel> {
  final int index;
  const ValorantTaglineInputField(this.index, {Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Tagline'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}$')),
            LengthLimitingTextInputFormatter(4),
          ],
          placeholder: '9999',
          onChanged: (tagline) {
            model.updateTaglineOrPlatform(tagline, index);
          },
          readOnly: false,
        ),
      ],
    );
  }
}

class ApexPlatformTypeInputField
    extends StackedHookView<TournamentRegistrationViewModel> {
  final int index;
  const ApexPlatformTypeInputField(this.index, {Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
    List<Widget> buildModeItem() {
      return model.platformList
          .map((e) => MySelectionItem(
                isForList: true,
                title: e,
              ))
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Platform type'),
        UIHelper.verticalSpaceSmall(),
        DirectSelect(
          mode: DirectSelectMode.tap,
          itemExtent: 45.0,
          selectedIndex: model.getSelectedPlatformIndex[index],
          // backgroundColor: Colors.red,
          onSelectedItemChanged: (value) {
            model.updateSelectedPlatformIndex(value, index);
          },
          items: buildModeItem(),
          child: MySelectionItem(
            isForList: false,
            title: model.platformList[model.getSelectedPlatformIndex[index]],
          ),
        ),
      ],
    );
  }
}

//You can use any Widget
class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key? key, required this.title, this.isForList = true})
      : super(key: key);

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: isForList
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildItem(context),
            )
          : Card(
              // margin: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: kcLightGreyColor),
                      borderRadius: BorderRadius.circular(8.0),
                      color: kcVeryLightGreyColor,
                    ),
                    child: _buildItem(context),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.unfold_more),
                  )
                ],
              ),
            ),
    );
  }
}
