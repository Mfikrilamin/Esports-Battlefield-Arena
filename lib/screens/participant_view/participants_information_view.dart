import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/screens/participant_view/participant_information_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

@RoutePage()
class ParticipantInformationView extends StatelessWidget {
  const ParticipantInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParticipantInformationViewModel>.reactive(
      viewModelBuilder: () => ParticipantInformationViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: kcPrimaryColor,
              title: BoxText.appBar('ARENA', color: kcDarkTextColor),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                color: kcDarkTextColor,
                onPressed: () {
                  model.navigateBack();
                },
                icon: const Icon(Icons.arrow_back),
              )),
          body: LiquidPullToRefresh(
            onRefresh: model.refreshParticipant,
            color: kcPrimaryColor,
            animSpeedFactor: 2,
            backgroundColor: kcPrimaryLightColor,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      const BoxText.headingThree('My Tournament'),
                      const Spacer(),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          // model.navigateToCreateTournament();
                        },
                        icon: const Icon(Icons.add),
                      ),
                      // )
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
