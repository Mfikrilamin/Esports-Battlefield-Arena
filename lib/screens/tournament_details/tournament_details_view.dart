import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/components/widgets/box_game_logo.dart';
import 'package:esports_battlefield_arena/components/widgets/hero_widget.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/tournament_details/tournament_details_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

@RoutePage()
class TournamentDetailView extends StatelessWidget {
  final Tournament tournament;
  const TournamentDetailView({Key? key, required this.tournament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TournamentDetailViewModel>.reactive(
      viewModelBuilder: () => TournamentDetailViewModel(),
      onModelReady: (model) {
        model.getOrganizerName(tournament.organizerId);
      },
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.25,
              elevation: 0,
              snap: true,
              floating: true,
              stretch: true,
              backgroundColor: (tournament.game == GameType.ApexLegend.name)
                  ? kcTertiaryColor
                  : kcDarkBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: HeroWidget(
                  tag: tournament.tournamentId,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2),
                      child: buildGameLogo(tournament.game, double.infinity)),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Transform.translate(
                    offset: const Offset(0, 1),
                    child: Container(
                      height: 45,
                      decoration: const BoxDecoration(
                        color: kcWhiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 8,
                          decoration: BoxDecoration(
                            color: kcLightGreyColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.51,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  color: kcWhiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInUp(
                                  from: 60,
                                  child: BoxText.headingTwo(tournament.title),
                                ),
                                UIHelper.verticalSpaceSmall(),
                                FadeInUp(
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
                                FadeInUp(
                                  from: 60,
                                  child: const BoxText.headingThree(
                                    'MYR',
                                  ),
                                ),
                                FadeInUp(
                                  from: 60,
                                  child: BoxText.headingThree(
                                    '${tournament.prizePool}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      UIHelper.verticalSpaceMedium(),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        from: 60,
                        child: BoxText.caption(tournament.description),
                      ),
                      UIHelper.verticalSpaceMediumLarge(),
                      TournamentDate(tournament: tournament),
                      UIHelper.verticalSpaceMediumLarge(),
                      TournamentParticipantInformation(
                        tournament: tournament,
                      ),
                      UIHelper.verticalSpaceMediumLarge(),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        from: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BoxText.headingFour('Organized by'),
                            UIHelper.verticalSpaceSmall(),
                            BoxText.body(model.organizerName),
                            // FutureBuilder(
                            //   future: model
                            //       .getOrganizerName(tournament.organizerId),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasData) {
                            //       return BoxText.body(snapshot.data.toString());
                            //     } else {
                            //       return BoxText.body(tournament.organizerId);
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceMediumLarge(),
                      FadeInUp(
                        delay: const Duration(milliseconds: 500),
                        from: 60,
                        child: const BoxText.headingThree('Rules'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  from: 60,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    color: kcWhiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoxText.body('${index + 1}. '),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: BoxText.body(
                            tournament.rules[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: tournament.rules.length),
            ),
            SliverToBoxAdapter(
              child: FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: HeroWidget(
                  tag: 'registerButton',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    color: kcWhiteColor,
                    child: BoxButton(
                      title: 'Register',
                      onTap: () => model.registerTournament(tournament),
                      busy: model.isBusy,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentDate extends StatelessWidget {
  const TournamentDate({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UIHelper.verticalSpaceMedium(),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: const Icon(
                    Icons.calendar_today,
                    size: 16,
                    // color: kcPrimaryColor,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: const BoxText.headingFive('Start Date'),
                ),
              ],
            ),
            UIHelper.verticalSpaceSmall(),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              from: 60,
              child: BoxText.body(tournament.startDate),
            ),
          ],
        ),
        UIHelper.horizontalSpaceMediumLarge(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UIHelper.verticalSpaceMedium(),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: const Icon(
                    Icons.calendar_today,
                    size: 16,
                    // color: kcPrimaryColor,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: const BoxText.headingFive('End Date'),
                ),
              ],
            ),
            UIHelper.verticalSpaceSmall(),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              from: 60,
              child: BoxText.body(tournament.endDate),
            ),
          ],
        ),
      ],
    );
  }
}

class TournamentParticipantInformation extends StatelessWidget {
  const TournamentParticipantInformation({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // UIHelper.verticalSpaceMedium(),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: const BoxText.headingFive('Mode'),
                ),
              ],
            ),
            UIHelper.verticalSpaceSmall(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // UIHelper.verticalSpaceMedium(),

                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: const Icon(
                    Icons.people_alt_outlined,
                    size: 20,
                    color: kcMediumGreyColor,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  from: 60,
                  child: BoxText.body(tournament.isSolo ? 'Solo' : 'Team'),
                ),
              ],
            ),
          ],
        ),
        UIHelper.horizontalSpaceMedium(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              from: 60,
              child: const BoxText.headingFive('Member(s)'),
            ),
            UIHelper.verticalSpaceSmall(),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              from: 60,
              child: BoxText.body(tournament.maxMemberPerTeam.toString()),
            ),
          ],
        ),
        UIHelper.horizontalSpaceMedium(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              from: 60,
              child: const BoxText.headingFive('Participants'),
            ),
            UIHelper.verticalSpaceSmall(),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              from: 60,
              child: BoxText.body(
                  '${tournament.currentParticipant.length} \\ ${tournament.maxParticipants}'),
            ),
          ],
        ),
      ],
    );
  }
}
