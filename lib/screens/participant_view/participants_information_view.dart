import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/screens/participant_view/participant_information_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: BoxText.headingThree('All participants'),
                ),
                model.participantList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.participantList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: BoxText.subheading(
                                    'Team : ${model.participantList[index].teamName}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BoxText.body(
                                        'Country : ${model.participantList[index].country}'),
                                    UIHelper.verticalSpaceSmall(),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: model.playerList[index].length,
                                      itemBuilder: (context, index2) {
                                        return BoxText.body(
                                            'Player ${index2 + 1} : ${model.playerList[index][index2].firstName + ' ' + model.playerList[index][index2].lastName} (${model.participantList[index].usernameList[index2]['username']})');
                                      },
                                    ),
                                  ],
                                ),
                                trailing: BoxText.subheading2(
                                    'Seeding : ${model.participantList[index].seeding.toString()}'),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: const [
                            SizedBox(
                              height: 200,
                              child: Center(
                                child:
                                    BoxText.headingThree('No participant yet'),
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
