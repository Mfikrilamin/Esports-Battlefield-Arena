import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:stacked/stacked.dart';

class TournamentDetailViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();

  Future<void> registerTournament(Tournament tournament) async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 2));
    setBusy(false);
    _router.push(TournamentRegistrationRoute(tournament: tournament));
  }
}
