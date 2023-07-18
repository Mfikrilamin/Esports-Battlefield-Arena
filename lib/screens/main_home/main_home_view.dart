import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/components/widgets/box_game_logo.dart';
import 'package:esports_battlefield_arena/components/widgets/hero_widget.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/main_home/main_home_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class MainHomeView extends StatelessWidget {
  const MainHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainHomeViewModel>.reactive(
      viewModelBuilder: () => MainHomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kcPrimaryColor,
            title: BoxText.appBar('ARENA', color: kcDarkTextColor),
            centerTitle: true,
          ),
          body: LiquidPullToRefresh(
            onRefresh: model.refreshTournaments,
            color: kcPrimaryColor,
            animSpeedFactor: 2,
            backgroundColor: kcPrimaryLightColor,
            height: 100,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: 25,
                          child: const BoxText.headingFive(
                            'No',
                          )),
                      Container(
                        alignment: Alignment.center,
                        width: 120,
                        child: const BoxText.headingFive(
                          'Tournament',
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 75,
                          child: const BoxText.headingFive(
                            'Start date',
                          )),
                      Container(
                        alignment: Alignment.center,
                        width: 75,
                        child: const BoxText.headingFive(
                          'End date',
                        ),
                      ),
                    ],
                  ),
                ),
                model.tournamentList.isNotEmpty
                    // If tournament is not empty, we build the list of tournaments card
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: model.tournamentList.length,
                          itemBuilder: (context, index) {
                            return TournamentCard(
                              key: UniqueKey(),
                              index: index,
                            );
                          },
                        ),
                      )
                    :
                    // If tournament empty we show a message
                    ListView(
                        shrinkWrap: true,
                        children: const [
                          SizedBox(
                            height: 200,
                            child: Center(
                              child:
                                  BoxText.headingThree('No tournament found'),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TournamentCard extends StackedHookView<MainHomeViewModel> {
  final int index;
  final double _ACTIVEHEIGHT = 250;
  final double _INACTIVEHEIGHT = 80;

  const TournamentCard({
    required this.index,
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, MainHomeViewModel model) {
    return GestureDetector(
      onTap: () {
        if (model.selectedIndex != index) {
          model.updateSelectedIndex(index);
        } else {
          model.navigateToTournamentDetail(index);
        }
      },
      child: AnimatedContainer(
        height: model.selectedIndex == index ? _ACTIVEHEIGHT : _INACTIVEHEIGHT,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5.0,
        ),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: kcLightGreyColor,
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: model.selectedIndex == index
              ? kcPrimaryColor.withOpacity(0.6)
              : kcBackgroundColor,
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: const AlwaysStoppedAnimation(1.0),
            curve: Curves.easeInOut,
          ),
          child: TournamentCardSt(
            tournament: model.tournamentList[index],
            index: index,
            organizerName: model.organizerName[index],
            isExpanded: model.selectedIndex == index,
          ),
        ),
      ),
    );
  }
}

class TournamentCardSt extends StatelessWidget {
  final double _INACTIVETOP = 25;
  final double _ACTIVEDATETOP = 155.5;
  final Tournament tournament;
  final String organizerName;
  final int index;
  final bool isExpanded;
  const TournamentCardSt(
      {Key? key,
      required this.tournament,
      required this.index,
      required this.isExpanded,
      required this.organizerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _INACTIVETOP,
            left: 5,
            child: SizedBox(
              width: 20,
              child: AnimatedOpacity(
                opacity: isExpanded ? 0 : 1,
                duration: const Duration(milliseconds: 400),
                child: BoxText.body(
                  (index + 1).toString(),
                  color: kcVeryDarkGreyTextColor,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: !isExpanded ? _INACTIVETOP : 10,
            left: !isExpanded ? 45 : 0,
            child: AnimatedDefaultTextStyle(
              style: TextStyle(
                fontSize: isExpanded ? 20 : 16,
                fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w400,
                color: kcVeryDarkGreyTextColor,
              ),
              duration: const Duration(milliseconds: 400),
              child: SizedBox(
                width: !isExpanded ? 120 : 350,
                child: Text(
                  tournament.title,
                  maxLines: !isExpanded ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: !isExpanded ? _INACTIVETOP + 3 : _ACTIVEDATETOP,
            left: !isExpanded ? 185 : 0,
            child: SizedBox(
              width: 70,
              child: BoxText.caption(
                tournament.startDate,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: !isExpanded ? _INACTIVETOP + 3 : _ACTIVEDATETOP,
            left: !isExpanded ? 285 : 91.5,
            child: SizedBox(
              width: 70,
              child: BoxText.caption(
                tournament.endDate,
              ),
            ),
          ),
          isExpanded
              ? SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      UIHelper.verticalSpaceSmall(),
                      UIHelper.verticalSpaceLarge(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoxText.body(
                                'Prize pool',
                              ),
                              BoxText.headingFour('RM ${tournament.prizePool}'),
                              UIHelper.verticalSpaceMedium(),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BoxText.body('Start Date'),
                                      const BoxText.caption(''),
                                    ],
                                  ),
                                  UIHelper.horizontalSpaceMedium(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BoxText.body('End Date'),
                                      const BoxText.caption(''),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              color:
                                  (tournament.game == GameType.ApexLegend.name)
                                      ? kcTertiaryColor
                                      : kcDarkBackgroundColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: HeroWidget(
                              tag: tournament.tournamentId,
                              child: buildGameLogo(tournament.game, 80),
                            ),
                          ),
                        ],
                      ),
                      UIHelper.verticalSpaceMedium(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoxText.body('Organized by'),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  organizerName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    // color: kcVeryDarkGreyTextColor,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoxText.body('Mode'),
                              BoxText.caption(
                                  tournament.isSolo ? 'Solo' : 'Team'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoxText.body('Total Participants'),
                              BoxText.caption('${tournament.maxParticipants}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
