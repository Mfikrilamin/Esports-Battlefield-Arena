import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/screens/view_leaderboard/leaderboard_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:carousel_slider/carousel_slider.dart';

@RoutePage()
class EditLeaderboardView extends StatelessWidget {
  final int roundIndex;
  final int matchIndex;
  final int matchResultIndex;
  const EditLeaderboardView(
      {super.key,
      required this.roundIndex,
      required this.matchIndex,
      required this.matchResultIndex});

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
              onPressed: () => model.navigateBackOnEditPage(
                  roundIndex, matchIndex, matchResultIndex),
            )),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              BoxText.headingThree('Game result $matchResultIndex'),
              UIHelper.verticalSpaceMedium(),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TeamRowField(
                          roundIndex: roundIndex,
                          matchIndex: matchIndex,
                          matchResultIndex: (matchResultIndex - 1),
                          index: index);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: model
                        .apexMatchResult[roundIndex]
                            [matchIndex.toString()]![matchResultIndex - 1]
                        .results
                        .length),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: BoxButton(
            title: 'Update leaderboard',
            onTap: () {
              model.upateApexLeaderboard(
                  roundIndex: roundIndex,
                  matchIndex: matchIndex,
                  matchResultIndex: matchResultIndex);
            },
          ),
        ),
      ),
    );
  }
}

class TeamRowField extends StackedHookView<LeaderboardViewModel> {
  const TeamRowField({
    super.key,
    required this.roundIndex,
    required this.matchIndex,
    required this.matchResultIndex,
    required this.index,
  });

  final int roundIndex;
  final int matchIndex;
  final int matchResultIndex;
  final int index;

  @override
  Widget builder(BuildContext context, LeaderboardViewModel model) {
    final _killController = useTextEditingController();
    final _placementController = useTextEditingController();
    print(model
        .apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex]
        .resultId);
    return Row(
      children: [
        Text((index + 1).toString()),
        UIHelper.horizontalSpaceSmall(),
        Expanded(
          child: Text(
            model
                .apexMatchResult[roundIndex]
                    [matchIndex.toString()]![matchResultIndex]
                .results[index]['teamName'],
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        // UIHelper.horizontalSpaceSmall(),
        SizedBox(
          width: 100,
          child: BoxInputField(
            readOnly: false,
            placeholder: 'placement',
            controller: _placementController,
            keyboardType: TextInputType.number,
            onChanged: (value) => model.updatePlacement(
                roundIndex, matchIndex, matchResultIndex, index, value),
          ),
        ),
        UIHelper.horizontalSpaceSmall(),
        SizedBox(
          width: 100,
          child: BoxInputField(
            readOnly: false,
            placeholder: 'kills',
            controller: _killController,
            keyboardType: TextInputType.number,
            onChanged: (value) => model.updateKill(
                roundIndex, matchIndex, matchResultIndex, index, value),
          ),
        ),
      ],
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

    final List<Widget> resultSliders =
        model.apexMatchResult[roundIndex][matchIndex.toString()]!.map(
      (item) {
        final textController = useTextEditingController();
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(5),
          // color: kcPrimaryColor,
          child: Column(
            children: [
              Row(
                children: [
                  BoxText.headingFive('Result Game ${item.gameNumber}'),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    visualDensity:
                        const VisualDensity(vertical: -4, horizontal: -4),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: BoxText.headingFive(
                                    'Result Game ${item.gameNumber} | result : ${item.resultId}'),
                              ),
                              // UIHelper.verticalSpaceSmall(),
                              // BoxText.body(
                              //   'This feature is not available yet',
                              //   color: kcTertiaryMediumColor,
                              // ),
                              // UIHelper.verticalSpaceSmall(),
                              // BoxInputField(
                              //   readOnly: model.isBusy,
                              //   controller: textController,
                              //   enable: false,
                              //   placeholder: 'Enter the Lobby Id',
                              //   onChanged: (lobbyId) {
                              //     model.updateResultLobbyId(roundIndex,
                              //         matchIndex, item.gameNumber, lobbyId);
                              //   },
                              // ),
                              // UIHelper.verticalSpaceSmall(),
                              // Center(
                              //   child: BoxButton(
                              //     title: 'submit',
                              //     height: 36,
                              //     // width: 150,
                              //     onTap: () {
                              //       model.submitLobbyId(
                              //         roundIndex,
                              //         matchIndex,
                              //         item.gameNumber,
                              //       );
                              //     },
                              //   ),
                              // ),
                              // UIHelper.verticalSpaceSmall(),
                              // const Center(
                              //   child: BoxText.headingFive('OR'),
                              // ),
                              UIHelper.verticalSpaceSmall(),
                              Center(
                                child: BoxButton(
                                  title: 'edit manually',
                                  height: 36,
                                  // width: 150,
                                  onTap: () {},
                                ),
                              ),
                              // Row(
                              //   children: const [
                              //     Icon(
                              //       Icons.error,
                              //       color: Colors.red,
                              //     ),
                              //     Text("Payment Failed"),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                  ),
                ],
              ),
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
                    title: Text(
                      '${item.results[resultTeamIndex]['teamName']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: kcMediumGreyColor,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
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
        );
      },
    ).toList();

    return SizedBox(
      height: 1000,
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
                height: 1150,
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

class LobbyIdInputField extends StackedHookView<LeaderboardViewModel> {
  const LobbyIdInputField({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, LeaderboardViewModel model) {
    var text = useTextEditingController();
    return BoxInputField(
      readOnly: model.isBusy,
      controller: text,
      placeholder: 'Enter Email',
      // errorText: model.emailValid ? null : 'Invalid Email',
      // onChanged: model.updateEmail,
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
    final textController = List.generate(
        model.valorantMatchResult[roundIndex][matchIndex.toString()]!.length,
        (_) => useTextEditingController());
    return ListView.builder(
      itemCount:
          model.valorantMatchResult[roundIndex][matchIndex.toString()]!.length,
      // : model.apexMatchResult[roundIndex][matchIndex.toString()]!
      // .length, // Replace with the actual item count
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int resultIndex) {
        return ListTile(
          title: BoxText.subheading2(
              'Game : ${model.valorantMatches[roundIndex][matchIndex].resultList[resultIndex]}'),
          subtitle: ListTile(
            contentPadding: const EdgeInsets.all(0),
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
            trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: BoxText.headingFive(
                                'Result Game ${(resultIndex + 1).toString()} | result : ${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].resultId}'),
                          ),
                          UIHelper.verticalSpaceSmall(),
                          model.isLobbyIdAvailable(
                                  roundIndex, matchIndex, resultIndex)
                              ? Center(
                                  child: BoxInputField(
                                    readOnly: true,
                                    controller: textController[resultIndex],
                                    placeholder:
                                        '${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].lobbyId}',
                                  ),
                                  // BoxText.body(
                                  //     'Lobby Id : ${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].lobbyId}'),
                                )
                              : BoxInputField(
                                  readOnly: model.isBusy,
                                  controller: textController[resultIndex],
                                  placeholder: 'Enter the Lobby Id',
                                  onChanged: (lobbyId) {
                                    model.updateResultLobbyId(roundIndex,
                                        matchIndex, resultIndex, lobbyId);
                                  },
                                ),
                          UIHelper.verticalSpaceSmall(),
                          model.isLobbyIdAvailable(
                                  roundIndex, matchIndex, resultIndex)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BoxButton(
                                      title: 'Reset',
                                      height: 36,
                                      width: 120,
                                      onTap: () {
                                        model.resetLobbyId(
                                          roundIndex,
                                          matchIndex,
                                          resultIndex,
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                    UIHelper.horizontalSpaceSmall(),
                                    BoxButton(
                                      title: 'Finish',
                                      height: 36,
                                      width: 120,
                                      onTap: () {
                                        model.finishLobby(
                                          roundIndex,
                                          matchIndex,
                                          resultIndex,
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                              : BoxButton(
                                  title: 'submit',
                                  height: 36,
                                  // width: 150,
                                  onTap: () {
                                    model.submitLobbyId(
                                      roundIndex,
                                      matchIndex,
                                      resultIndex,
                                    );
                                  },
                                ),
                          UIHelper.verticalSpaceSmall(),
                          const Center(
                            child: BoxText.headingFive('OR'),
                          ),
                          UIHelper.verticalSpaceSmall(),
                          Center(
                            child: BoxButton(
                              title: 'edit manually',
                              height: 36,
                              // width: 150,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: kcMediumGreyColor,
                )),
          ),
        );
      },
    );
  }
}
