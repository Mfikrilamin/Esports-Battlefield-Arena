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
                trailing: model.isOrganizer
                    ? (model.game == GameType.Valorant.name)
                        ? !model.valorantMatches[roundIndex][matchIndex]
                                .hasCompleted
                            ? IconButton(
                                onPressed: () async => {
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: BoxText.headingThree(!model
                                                    .showDialogErrorMessage
                                                ? 'Match finish?'
                                                : 'Something wrong happen!'),
                                          ),
                                          UIHelper.verticalSpaceMedium(),
                                          Center(
                                            child: BoxText.body(!model
                                                    .showDialogErrorMessage
                                                ? 'This action is irreversible, once finished you cannot edit the match result.'
                                                : 'Cannot finish match, no team found'),
                                          ),
                                          UIHelper.verticalSpaceMedium(),
                                          !model.showDialogErrorMessage
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Center(
                                                      child: BoxButton(
                                                        width: 100,
                                                        title: 'Yes',
                                                        height: 36,
                                                        // width: 150,
                                                        onTap: () {
                                                          model.matchFinish(
                                                            roundIndex,
                                                            matchIndex,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Center(
                                                      child: BoxButton(
                                                        outline: true,
                                                        title: 'No',
                                                        width: 100,
                                                        height: 36,
                                                        // width: 150,
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Center(
                                                  child: BoxButton(
                                                    title: 'Okay',
                                                    width: 100,
                                                    height: 36,
                                                    // width: 150,
                                                    onTap: () {
                                                      model
                                                          .updateShowDialogErrorMessageState(
                                                              false);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                          UIHelper.verticalSpaceSmall(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  model.showDialogErrorMessage
                                      ? await showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Center(
                                                  child: BoxText.headingThree(
                                                      'Something wrong happen!'),
                                                ),
                                                UIHelper.verticalSpaceMedium(),
                                                Center(
                                                  child: BoxText.body(
                                                      'Cannot finish match, no team found'),
                                                ),
                                                UIHelper.verticalSpaceMedium(),
                                                Center(
                                                  child: BoxButton(
                                                    title: 'Okay',
                                                    width: 100,
                                                    height: 36,
                                                    // width: 150,
                                                    onTap: () {
                                                      model
                                                          .updateShowDialogErrorMessageState(
                                                              false);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                UIHelper.verticalSpaceSmall(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                },
                                icon: const Icon(
                                  Icons.ads_click_rounded,
                                  color: kcDarkGreyColor,
                                ),
                              )
                            : const SizedBox.shrink()
                        : !model.apexMatches[roundIndex][matchIndex]
                                .hasCompleted
                            ? IconButton(
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Center(
                                            child: BoxText.headingThree(
                                                'Match finish?'),
                                          ),
                                          UIHelper.verticalSpaceMedium(),
                                          Center(
                                            child: BoxText.body(
                                                'This action is irreversible, once finished you cannot edit the match result.'),
                                          ),
                                          UIHelper.verticalSpaceMedium(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Center(
                                                child: BoxButton(
                                                  width: 100,
                                                  title: 'Yes',
                                                  height: 36,
                                                  // width: 150,
                                                  onTap: () {
                                                    model.matchFinish(
                                                      roundIndex,
                                                      matchIndex,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Center(
                                                child: BoxButton(
                                                  outline: true,
                                                  title: 'No',
                                                  width: 100,
                                                  height: 36,
                                                  // width: 150,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          UIHelper.verticalSpaceSmall(),
                                        ],
                                      ),
                                    ),
                                  ),
                                },
                                icon: const Icon(
                                  Icons.ads_click_rounded,
                                  color: kcDarkGreyColor,
                                ),
                              )
                            : const SizedBox.shrink()
                    : const SizedBox.shrink(),
                title: (model.game == GameType.Valorant.name)
                    ? BoxText.headingFour('Match ${matchIndex + 1}')
                    : BoxText.headingFour('Group ${matchIndex + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (model.game == GameType.Valorant.name)
                        ? BoxText.body(
                            '${model.valorantMatches[roundIndex][matchIndex].matchId}  ||  [${model.valorantMatches[roundIndex][matchIndex].teamAScore}]-[${model.valorantMatches[roundIndex][matchIndex].teamBScore}]')
                        : BoxText.body(
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
                                child: BoxText.headingThree(
                                    'Result Game ${item.gameNumber}'),
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Center(
                                child: BoxText.headingFive(
                                    'result : ${item.resultId}'),
                              ),
                              const Center(
                                child: SizedBox(
                                  width: 220,
                                  child: Text(
                                    'Are you sure want to edit the result manually?',
                                    style: TextStyle(
                                      color: kcMediumGreyColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Center(
                                child: BoxButton(
                                  title: 'Edit',
                                  height: 36,
                                  width: 150,
                                  onTap: () {
                                    // Navigator.pop(context);
                                    model.navigateToEditLeaderboardPage(
                                      roundIndex,
                                      matchIndex,
                                      item.gameNumber,
                                    );
                                  },
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
                  item.results.sort((a, b) {
                    return a['seed'].compareTo(b['seed']);
                  });
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
            minLeadingWidth: 0,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: kcPrimaryDarkerColor,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kcPrimaryColor,
                ),
                child: CircleAvatar(
                  // radius: 20,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    (resultIndex + 1).toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: kcDarkTextColor,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    model
                        .valorantMatchResult[roundIndex]
                            [matchIndex.toString()]![resultIndex]
                        .teamA,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kcMediumGreyColor,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '[${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].teamAScore}] - [${model.valorantMatchResult[roundIndex][matchIndex.toString()]![resultIndex].teamBScore}]',
                  style: const TextStyle(
                    fontSize: 14,
                    color: kcMediumGreyColor,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    model
                        .valorantMatchResult[roundIndex]
                            [matchIndex.toString()]![resultIndex]
                        .teamB,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kcMediumGreyColor,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: model.isOrganizer
                ? IconButton(
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
                              const Center(
                                child: BoxText.headingThree('Match finish?'),
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  BoxButton(
                                    title: 'No',
                                    height: 36,
                                    width: 120,
                                    outline: true,
                                    onTap: () {
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
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: kcMediumGreyColor,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
