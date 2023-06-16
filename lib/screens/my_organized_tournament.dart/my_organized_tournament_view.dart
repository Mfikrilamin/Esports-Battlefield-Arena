import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/components/widgets/box_game_logo.dart';
import 'package:esports_battlefield_arena/components/widgets/hero_widget.dart';
import 'package:esports_battlefield_arena/screens/my_organized_tournament.dart/my_organized_tournament_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class MyOrganizedTournamentView extends StatelessWidget {
  const MyOrganizedTournamentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyOrganizedTournamentViewModel>.reactive(
      viewModelBuilder: () => MyOrganizedTournamentViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kcPrimaryColor,
            title: BoxText.appBar('ARENA', color: kcDarkTextColor),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: LiquidPullToRefresh(
            onRefresh: model.refreshOrganizedTournament,
            color: kcPrimaryColor,
            animSpeedFactor: 2,
            backgroundColor: kcPrimaryLightColor,
            height: 100,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        const BoxText.headingThree('My Tournament'),
                        const Spacer(),
                        IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            model.navigateToCreateTournament();
                          },
                          icon: const Icon(Icons.add),
                        ),
                        // )
                      ],
                    ),
                  ),
                  model.organizedTournamentList.isNotEmpty
                      ? const Expanded(
                          child: TournamentCardBuilder(),
                        )
                      : const EmptyTournamentMessage()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EmptyTournamentMessage extends StatelessWidget {
  const EmptyTournamentMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        children: const [
          SizedBox(
            height: 200,
            child: Center(
              child: BoxText.headingThree('Create new tournament'),
            ),
          ),
        ],
      ),
    );
  }
}

class TournamentCardBuilder
    extends StackedHookView<MyOrganizedTournamentViewModel> {
  const TournamentCardBuilder({
    super.key,
  });

  @override
  Widget builder(BuildContext context, MyOrganizedTournamentViewModel model) {
    return ListView.separated(
      itemCount: model.organizedTournamentList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            model.navigateToTournamentDetail(index);
          },
          child: ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            leading: CircleAvatar(
                radius: 25,
                backgroundColor: model.organizedTournamentList[index].game ==
                        GameType.ApexLegend.name
                    ? kcTertiaryColor
                    : kcDarkBackgroundColor,
                child: HeroWidget(
                  tag: model.organizedTournamentList[index].tournamentId,
                  child: buildGameLogo(
                      model.organizedTournamentList[index].game, 35),
                )),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoxText.subheading2(model.organizedTournamentList[index].title),
                BoxText.ellipsis(
                    model.organizedTournamentList[index].description),
              ],
            ),
            trailing: Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: (() {
                  if (model.organizedTournamentList[index].status ==
                      GameStatus.pending.name) {
                    return kcLightGreyColor;
                  } else if (model.organizedTournamentList[index].status ==
                      GameStatus.ongoing.name) {
                    return kcOngoingColor;
                  } else {
                    return kcPrimaryColor;
                  }
                }()),
              ),
              child: Center(
                child: (() {
                  if (model.organizedTournamentList[index].status ==
                      GameStatus.pending.name) {
                    return BoxText.caption(GameStatus.pending.name);
                  } else if (model.organizedTournamentList[index].status ==
                      GameStatus.ongoing.name) {
                    return BoxText.caption(GameStatus.ongoing.name);
                  } else {
                    return BoxText.caption(GameStatus.completed.name);
                  }
                }()),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        // <-- SEE HERE
        return const Divider();
      },
    );
  }
}
