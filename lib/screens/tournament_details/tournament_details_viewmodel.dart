import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';

import 'package:stacked/stacked.dart';

class TournamentDetailViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();

  //State of the view
  String _organizerName = '';

  // Getters
  String get organizerName => _organizerName;

  // Setters
  void getOrganizerName(String id) async {
    Organizer organizer = Organizer.fromJson(
        await _database.get(id, FirestoreCollections.organizer));
    _organizerName = organizer.organizerName;
    notifyListeners();
  }

  Future<void> registerTournament(Tournament tournament) async {
    setBusy(true);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    setBusy(false);
    notifyListeners();
    _router.push(TournamentRegistrationRoute(tournament: tournament));
  }
}
