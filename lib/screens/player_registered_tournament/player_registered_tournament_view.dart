import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/components/widgets/box_game_logo.dart';
import 'package:esports_battlefield_arena/screens/player_registered_tournament/player_registered_tournament_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

@RoutePage()
class PlayerRegisteredTournamentView extends StatelessWidget {
  const PlayerRegisteredTournamentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PlayerRegisterTournamentViewModel>.reactive(
      onModelReady: (model) => model.refreshRegisteredTournament(),
      viewModelBuilder: () => PlayerRegisterTournamentViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kcPrimaryColor,
            title: BoxText.appBar('ARENA', color: kcDarkTextColor),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: LiquidPullToRefresh(
            onRefresh: model.refreshRegisteredTournament,
            // showChildOpacityTransition: false,
            color: kcPrimaryColor,
            animSpeedFactor: 2,
            backgroundColor: kcPrimaryLightColor,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: BoxText.headingThree('My Tournament'),
                ),
                model.registeredTournamentList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemCount: model.registeredTournamentList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                model.navigateToLeaderboard(index);
                              },
                              visualDensity: const VisualDensity(vertical: 3),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: model
                                            .registeredTournamentList[index]
                                            .game ==
                                        GameType.ApexLegend.name
                                    ? kcTertiaryColor
                                    : kcDarkBackgroundColor,
                                child: model.registeredTournamentList[index]
                                            .game ==
                                        GameType.ApexLegend.name
                                    ? const BoxGameLogo(
                                        src:
                                            'assets/images/Apex_Legends_logo.svg',
                                        width: 30,
                                        backgroundColor: kcTertiaryColor,
                                      )
                                    : const BoxGameLogo(
                                        src: 'assets/images/Valorant_logo.svg',
                                        width: 30,
                                        backgroundColor: kcTertiaryColor,
                                      ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BoxText.subheading2(model
                                      .registeredTournamentList[index].title),
                                  BoxText.ellipsis(model
                                      .registeredTournamentList[index]
                                      .description),
                                ],
                              ),
                              trailing: Container(
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: (() {
                                    if (model.registeredTournamentList[index]
                                            .status ==
                                        GameStatus.pending.name) {
                                      return kcLightGreyColor;
                                    } else if (model
                                            .registeredTournamentList[index]
                                            .status ==
                                        GameStatus.ongoing.name) {
                                      return kcOngoingColor;
                                    } else {
                                      return kcPrimaryColor;
                                    }
                                  }()),
                                ),
                                child: Center(
                                  child: (() {
                                    if (model.registeredTournamentList[index]
                                            .status ==
                                        GameStatus.pending.name) {
                                      return BoxText.caption(
                                          GameStatus.pending.name);
                                    } else if (model
                                            .registeredTournamentList[index]
                                            .status ==
                                        GameStatus.ongoing.name) {
                                      return BoxText.caption(
                                          GameStatus.ongoing.name);
                                    } else {
                                      return BoxText.caption(
                                          GameStatus.completed.name);
                                    }
                                  }()),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            // <-- SEE HERE
                            return const Divider();
                          },
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView(
                          children: const [
                            SizedBox(
                              height: 200,
                              child: Center(
                                child: BoxText.headingThree(
                                    'No tournaments available'),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
