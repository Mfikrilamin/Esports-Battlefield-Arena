import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/screens/view_leaderboard/leaderboard_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:carousel_slider/carousel_slider.dart';

@RoutePage()
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaderboardViewModel>.reactive(
      viewModelBuilder: () => LeaderboardViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            backgroundColor: kcPrimaryColor,
            title: BoxText.appBar('LEADERBOARD', color: kcDarkTextColor),
            centerTitle: true,
            // automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: kcDarkTextColor,
              ),
              onPressed: () => model.navigateBack(),
            )),
        body: LiquidPullToRefresh(
          onRefresh: model.refreshLeadboard,
          color: kcPrimaryColor,
          animSpeedFactor: 2,
          backgroundColor: kcPrimaryLightColor,
          height: 100,
          child: ListView(
            children: [
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int roundIndex, bool isExpanded) {
                  model.updateRoundPanel(roundIndex,
                      isExpanded); // Toggle the expansion state for the corresponding panel
                },
                children:
                    List.generate(model.roundExpanded.length, (roundIndex) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: BoxText.headingTwo('Round ${roundIndex + 1}'),
                      );
                    },
                    body: MatchInformation(
                      roundIndex,
                    ),
                    isExpanded: model.roundExpanded[roundIndex],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchInformation extends StackedHookView<LeaderboardViewModel> {
  final int roundIndex;
  const MatchInformation(
    this.roundIndex, {
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, LeaderboardViewModel model) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int matchIndex, bool isExpanded) {
        model.updateMatchPanel(roundIndex, matchIndex,
            isExpanded); // Toggle the expansion state for the corresponding panel
      },
      children: List.generate(
        model.matchExpanded[roundIndex].length,
        (matchIndex) {
          return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: (model.game == GameType.Valorant.name)
                    ? BoxText.headingFour('Match ${matchIndex + 1}')
                    : BoxText.headingFour('Group ${matchIndex + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (model.game == GameType.Valorant.name)
                        ?
                        // BoxText.body(
                        //     'Team ${model.valorantMatches[roundIndex][matchIndex].teamA} vs Team ${model.valorantMatches[roundIndex][matchIndex].teamB}')
                        BoxText.body(model
                            .valorantMatches[roundIndex][matchIndex].matchId)
                        :
                        // BoxText.body(
                        //     'Total number of team : ${model.apexMatches[roundIndex][matchIndex].teamList.length}'),
                        BoxText.body(
                            model.apexMatches[roundIndex][matchIndex].matchId),
                    BoxText.caption(
                        'Winner to : ${model.getNextRoundMatch(roundIndex, matchIndex)}'),
                  ],
                ),
              );
            },
            body: model.isResultAvailable(roundIndex, matchIndex)
                ? (model.game == GameType.Valorant.name)
                    ? ValorantResultCardListBuilder(
                        roundIndex: roundIndex,
                        matchIndex: matchIndex,
                      )
                    : !model.isBusy
                        ? ApexResultCardListBuilder(
                            roundIndex: roundIndex,
                            matchIndex: matchIndex,
                          )
                        : const CircularProgressIndicator()
                : BoxText.subheading2('No result available'),
            isExpanded: model.matchExpanded[roundIndex][matchIndex],
          );
        },
      ),
    );
  }
}

class ApexResultCardListBuilder extends StackedHookView<LeaderboardViewModel> {
  final int roundIndex;
  final int matchIndex;
  const ApexResultCardListBuilder({
    required this.roundIndex,
    required this.matchIndex,
    super.key,
  });

  @override
  Widget builder(BuildContext context, LeaderboardViewModel model) {
    final CarouselController controller = CarouselController();
    final List<Widget> resultSliders = model.apexMatchResult[roundIndex]
            [matchIndex.toString()]!
        .map(
          (item) => Container(
            width: double.infinity,
            margin: const EdgeInsets.all(5),
            // color: kcPrimaryColor,
            child: Column(
              children: [
                BoxText.headingFive('Result ${item.gameNumber}'),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  style: ListTileStyle.list,
                  minVerticalPadding: 0,
                  minLeadingWidth: 20,
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const BoxText.caption('No'),
                  title: const BoxText.caption('Team'),
                  trailing: SizedBox(
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(
                          width: 60,
                          child: Center(child: BoxText.caption('placement')),
                        ),
                        SizedBox(
                          width: 40,
                          child: Center(child: BoxText.caption('kills')),
                        ),
                        SizedBox(
                          width: 40,
                          child: Center(child: BoxText.caption('points')),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: item.results.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int resultTeamIndex) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 0.0, right: 0.0),
                      visualDensity: const VisualDensity(vertical: -3),
                      minLeadingWidth: 20,
                      horizontalTitleGap: 0,
                      leading: BoxText.body(
                        '${resultTeamIndex + 1}',
                      ),
                      title: BoxText.body(
                          'Team ${item.results[resultTeamIndex]['participantId']}'),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: BoxText.body(
                                    '${item.results[resultTeamIndex]['placement']}'),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: BoxText.body(
                                    '${item.results[resultTeamIndex]['kills']}'),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: BoxText.body(
                                    '${item.results[resultTeamIndex]['points']}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
        .toList();

    return SizedBox(
      height: 980,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: resultSliders,
              options: CarouselOptions(
                // autoPlay: true,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                viewportFraction: 0.85,
                height: 1120,
                onPageChanged: (index, reason) {
                  // later use
                  model.updateCarousellSelectedIndex(
                      roundIndex, matchIndex, index);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: model.apexMatchResult[roundIndex][matchIndex.toString()]!
                .asMap()
                .entries
                .map((entry) {
              return GestureDetector(
                onTap: () => controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(model.carousellCurrentIndex == entry.key
                            ? 0.9
                            : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ValorantResultCardListBuilder
    extends StackedHookView<LeaderboardViewModel> {
  final int roundIndex;
  final int matchIndex;
  const ValorantResultCardListBuilder({
    super.key,
    required this.roundIndex,
    required this.matchIndex,
  });

  @override
  Widget builder(BuildContext context, LeaderboardViewModel model) {
    return ListView.builder(
      itemCount:
          model.valorantMatchResult[roundIndex][matchIndex.toString()]!.length,
      // : model.apexMatchResult[roundIndex][matchIndex.toString()]!
      // .length, // Replace with the actual item count
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int resultIndex) {
        return ListTile(
          title: BoxText.subheading2('Game :'),
          subtitle: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: kcPrimaryDarkerColor,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kcPrimaryColor,
                ),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    (resultIndex + 1).toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: kcDarkTextColor,
                    ),
                  ),
                ),
              ),
            ),
            title: BoxText.body(
                '${model.valorantMatches[roundIndex][matchIndex].teamA} [${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].teamAScore}] - [${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].teamBScore}] ${model.valorantMatches[roundIndex][matchIndex].teamB}'),
          ),
        );
      },
    );
  }
}
