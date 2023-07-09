import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/components/widgets/bottom_nagivation_bar.dart';
import 'package:esports_battlefield_arena/screens/home/home_viewmodel.dart';
import 'package:esports_battlefield_arena/screens/my_organized_tournament.dart/my_organized_tournament_view.dart';
import 'package:esports_battlefield_arena/screens/payment_history/payment_history_view.dart';
import 'package:esports_battlefield_arena/screens/main_home/main_home_view.dart';
import 'package:esports_battlefield_arena/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../player_registered_tournament/player_registered_tournament_view.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  // static Route route() => MaterialPageRoute(builder: (_) => const HomeView());
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        model.currentUserIsPlayer();
      },
      builder: (context, model, child) => Scaffold(
        // appBar: ,
        body: model.isBusy
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: model.selectedIndex,
                children: [
                  model.isPlayer
                      ? const MainHomeView()
                      : const MyOrganizedTournamentView(),
                  model.isPlayer
                      ? const PlayerRegisteredTournamentView()
                      : const ProfileView(),
                  model.isPlayer ? const PaymentHistoryView() : Container(),
                  const ProfileView(),
                ],
              ),

        // buildBodyWidget(model.selectedIndex, model.isPlayer),
        bottomNavigationBar: CustomBottomNavigationBar(model.isPlayer),
      ),
    );
  }
}
