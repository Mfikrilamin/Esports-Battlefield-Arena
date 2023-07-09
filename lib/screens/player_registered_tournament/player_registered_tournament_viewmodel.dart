import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';

import 'package:stacked/stacked.dart';

class PlayerRegisterTournamentViewModel extends ReactiveViewModel {
  Database _database = locator<Database>();
  Auth _auth = locator<Auth>();
  LogService _log = locator<LogService>();
  final AppRouter _router = locator<AppRouter>();
  final _tournamentService = locator<TournamentService>();
  List<Tournament> _registeredTournamentList = [];

  List<Tournament> get registeredTournamentList => _registeredTournamentList;

  Future<void> refreshRegisteredTournament() async {
    try {
      if (_auth.currentUser() == null) {
        _router.popUntilRoot();
        _router.push(const SignInRoute());
        return Future.delayed(const Duration(seconds: 2));
      }
      List<Map<String, dynamic>> userParticipationsData =
          await _database.getAllByQueryList('memberList', _auth.currentUser()!,
              FirestoreCollections.tournamentParticipant);
      _log.debug('participant size :  ${userParticipationsData.length}');
      List<TournamentParticipant> tournamentParticipantList =
          userParticipationsData
              .map((e) => TournamentParticipant.fromJson(e))
              .toList();
      _log.debug('Tournament size :  ${tournamentParticipantList.length}');

      _registeredTournamentList.clear();
      for (TournamentParticipant participant in tournamentParticipantList) {
        if (participant.hasPay == true) {
          Tournament tournament = Tournament.fromJson(await _database.get(
              participant.tournamentId, FirestoreCollections.tournament));
          _registeredTournamentList.add(tournament);
        }
      }
      _log.debug('Tournament size :  ${_registeredTournamentList.length}');
      notifyListeners();
      return Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _log.debug(e.toString());
    }
  }

  Future<void> navigateToLeaderboard(int index) async {
    await _tournamentService
        .getLeaderboardResult(_registeredTournamentList[index]);
    _router.push(const LeaderboardRoute());
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];
}
