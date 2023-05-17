import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/service.dart';
import 'package:stacked/stacked.dart';

class MyOrganizedTournamentViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final log = locator<LogService>();
  final Auth _auth = locator<Auth>();
  final LogService _log = locator<LogService>();

  //State of the view
  List<Tournament> _organizedTournamentList = [];

  //getter
  List<Tournament> get organizedTournamentList => _organizedTournamentList;

  //Navigation
  void navigateToCreateTournament() {
    _router.push(CreateTournamentRoute());
  }

  void navigateToTournamentDetail(int index) {
    _router.push(OrganizedTournamentDetailRoute(
        tournament: _organizedTournamentList[index]));
  }

  Future<void> refreshOrganizedTournament() async {
    String? currentOrganizerId = _auth.currentUser();
    if (currentOrganizerId == null) {
      //send back to sign in page
      _router.popUntil((route) => route.settings.name == SignInRoute.name);
    }

    //get tournament list
    List<Map<String, dynamic>> tournamentDataList = await _database
        .getAllByQuery(['organizerId'], [currentOrganizerId!],
            FirestoreCollections.tournament);

    if (_organizedTournamentList.isNotEmpty) {
      _organizedTournamentList.clear();
    }
    _organizedTournamentList =
        tournamentDataList.map((data) => Tournament.fromJson(data)).toList();
    notifyListeners();
  }

  @override
  Future<void> futureToRun() {
    refreshOrganizedTournament();
    return Future.value();
  }
}
