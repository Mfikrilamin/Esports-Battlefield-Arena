import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';

class OrganizedTournamentDetailViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final log = locator<LogService>();
  final Auth _auth = locator<Auth>();
  final LogService _log = locator<LogService>();
  final _tournamentService = locator<TournamentService>();

  void updateTournament(Tournament tournament) {
    _tournamentService.updateTournament(tournament);
    notifyListeners();
  }

  void navigateToEditTournament(Tournament tournament) {
    updateTournament(tournament);
    _router.push(const CreateTournamentRoute());
  }

  Future<void> registerTournament(Tournament tournament) async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 1));
    setBusy(false);
    _router.push(TournamentRegistrationRoute(tournament: tournament));
  }

  Future<String> getOrganizerName(String organizerId) async {
    Organizer _organizer = Organizer.fromJson(
        await _database.get(organizerId, FirestoreCollections.organizer));
    return _organizer.organizerName;
  }

  @override
  // TODO: implement reactiveServices
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];
}
