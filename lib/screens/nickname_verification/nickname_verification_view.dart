import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:direct_select/direct_select.dart';
import 'package:esports_battlefield_arena/components/widgets/hero_widget.dart';
import 'package:esports_battlefield_arena/screens/nickname_verification/nickname_verification_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class NicknameVerificationView extends StatelessWidget {
  final List<String> emailList;
  final GameType gameType;
  const NicknameVerificationView(
      {super.key, required this.emailList, required this.gameType});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NicknameVerificationViewModel>.reactive(
      viewModelBuilder: () => NicknameVerificationViewModel(),
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
                          child: const BoxText.headingThree(
                              'Participant game information'),
                        ),
                        UIHelper.verticalSpaceSmall(),
                        FadeInRight(
                          delay: const Duration(milliseconds: 500),
                          from: 60,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: emailList.length,
                            itemBuilder: (context, index) {
                              return ParticipantInformation(
                                index: index,
                                gameType: gameType,
                                email: emailList[index],
                                key: UniqueKey(),
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
                        // model.registerTournament(
                        //     tournament.tournamentId,
                        //     context,
                        //     isSolo: tournament.isSolo,
                        //     (tournament.game == GameType.Valorant.name)
                        //         ? 5
                        //         : tournament.isSolo
                        //             ? 1
                        //             : 3),
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

class ParticipantInformation
    extends StackedHookView<NicknameVerificationViewModel> {
  final GameType gameType;
  final String email;
  final int index;
  const ParticipantInformation({
    required this.gameType,
    required this.email,
    required this.index,
    super.key,
  });

  @override
  Widget builder(BuildContext context, NicknameVerificationViewModel model) {
    return FadeInRight(
      delay: const Duration(milliseconds: 200),
      from: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BoxText.headingThree('Player ${index + 1}'),
              const Spacer(),
              IconButton(
                onPressed: model.verifyUsernameInformation(email),
                icon: const Icon(
                  Icons.verified,
                  color: kcPrimaryDarkerColor,
                ),
              )
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          FadeInRight(
            from: 60,
            delay: const Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmailInputField(email: email),
                UIHelper.verticalSpaceSmall(),
                UsernameInputField(gameType),
                UIHelper.verticalSpaceSmall(),
                if (gameType == GameType.Valorant)
                  const ValorantTaglineInputField()
                else
                  const ApexPlatformTypeInputField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmailInputField extends StackedHookView<NicknameVerificationViewModel> {
  final String email;
  const EmailInputField({Key? key, required this.email})
      : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, NicknameVerificationViewModel model) {
    var text = useTextEditingController(text: email);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Email'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: email,
          onChanged: null,
          readOnly: true,
        ),
      ],
    );
  }
}

class UsernameInputField
    extends StackedHookView<NicknameVerificationViewModel> {
  final GameType gameType;
  const UsernameInputField(this.gameType, {Key? key})
      : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, NicknameVerificationViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Username'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          placeholder: 'Enter your game username',
          onChanged: (username) {
            if (gameType == GameType.ApexLegend) {
              model.updateApexUsername(username);
            } else {
              model.updateValorantUsername(username);
            }
          },
          readOnly: false,
        ),
      ],
    );
  }
}

class ValorantTaglineInputField
    extends StackedHookView<NicknameVerificationViewModel> {
  const ValorantTaglineInputField({Key? key})
      : super(key: key, reactive: false);
  @override
  Widget builder(BuildContext context, NicknameVerificationViewModel model) {
    var text = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxText.body('Tagline'),
        UIHelper.verticalSpaceSmall(),
        BoxInputField(
          controller: text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^#\d{4}$'))
          ],
          placeholder: '#9999',
          onChanged: (tagline) {
            model.updateValorantTagline(tagline);
          },
          readOnly: false,
        ),
      ],
    );
  }
}

class ApexPlatformTypeInputField
    extends StackedHookView<NicknameVerificationViewModel> {
  const ApexPlatformTypeInputField({Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, NicknameVerificationViewModel model) {
    List<Widget> buildModeItem() {
      return model.platformList
          .map((e) => MySelectionItem(
                isForList: true,
                title: e,
              ))
          .toList();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body('Platform type'),
          UIHelper.verticalSpaceSmall(),
          DirectSelect(
            mode: DirectSelectMode.tap,
            itemExtent: 45.0,
            selectedIndex: model.platformSelectedIndex,
            // backgroundColor: Colors.red,
            onSelectedItemChanged: model.updateSelectedPlatformIndex,
            items: buildModeItem(),
            child: MySelectionItem(
              isForList: false,
              title: model.platformList[model.platformSelectedIndex],
            ),
          ),
        ],
      ),
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
