import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/screens/view_leaderboard/leaderboard_viewmodel.dart';
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
