import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
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
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class TournamentRegistrationView extends StatelessWidget {
  final Tournament tournament;
  final List _controllers = [];

  TournamentRegistrationView({super.key, required this.tournament});

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
                        FadeInRight(
                          from: 70,
                          delay: const Duration(milliseconds: 200),
                          child: BoxText.headingThree('Tournament Details'),
                        ),
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
                                    child:
                                        BoxText.headingFour(tournament.title),
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
                                children: [
                                  FadeInRight(
                                    from: 60,
                                    child: const BoxText.headingFour(
                                      'MYR',
                                    ),
                                  ),
                                  FadeInRight(
                                    from: 60,
                                    child: BoxText.headingFour(
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
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                (tournament.game == GameType.Valorant.name)
                                    ? 5
                                    : tournament.isSolo
                                        ? 1
                                        : 3,
                            itemBuilder: (context, index) {
                              model.setPlayerEmailController(
                                  tournament.game, tournament.isSolo);
                              return EmailInputFieldPlayer(
                                index: index,
                                onChanged: (email) {
                                  model.updatePlayerEmail(email, index);
                                },
                              );
                            },
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
                      title: 'Pay',
                      onTap: () => {
                        model.registerTournament(),
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

// class EmailInputFieldPlayer
//     extends StackedHookView<TournamentRegistrationViewModel> {
//   final int index;
//   const EmailInputFieldPlayer(this.index, {Key? key})
//       : super(key: key, reactive: true);

//   @override
//   Widget builder(BuildContext context, TournamentRegistrationViewModel model) {
//     print('EmailInputFieldPlayer${index + 1} is being built');
//     var text = useTextEditingController();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         BoxText.body('Player ${index + 1}'),
//         UIHelper.verticalSpaceSmall(),
//         BoxInputField(
//           controller: text,
//           placeholder: 'Player1 Email',
//           onChanged: (value) => model.updatePlayerEmail(value, index),
//           readOnly: false,
//           // errorText: model.emailIsValid(index) ? null : 'Invalid Email',
//         ),
//       ],
//     );
//   }
// }

class EmailInputFieldPlayer extends StatefulWidget {
  final int index;
  final void Function(String) onChanged;
  const EmailInputFieldPlayer({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  State<EmailInputFieldPlayer> createState() => _EmailInputFieldPlayerSTState();
}

class _EmailInputFieldPlayerSTState extends State<EmailInputFieldPlayer> {
  bool isValid = true;
  var text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('EmailInputFieldPlayer${widget.index + 1} is being built');
    // var text = useTextEditingController();
    return ValueListenableBuilder(
      valueListenable: text,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpaceSmall(),
            BoxText.body('Player ${widget.index + 1}'),
            UIHelper.verticalSpaceSmall(),
            BoxInputField(
              controller: text,
              placeholder: 'Player${widget.index + 1} Email',
              onChanged: (value) {
                widget.onChanged(value);
                setState(() {
                  isValid = RegexValidation.validateEmail(value);
                });
              },
              readOnly: false,
              errorText: isValid ? null : 'Invalid Email',
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    text.dispose();
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
