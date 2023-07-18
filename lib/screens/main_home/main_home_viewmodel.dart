import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:stacked/stacked.dart';

class MainHomeViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final log = locator<LogService>();
  final LogService _log = locator<LogService>();

  //Tournament card state
  int _selectedIndex = 0;
  bool _isExpanded = false;
  List<Tournament> _tournamentListState = [];
  List<String> _organizerName = [];

  //getters
  int get selectedIndex => _selectedIndex;
  bool get isExpanded => _isExpanded;
  List<Tournament> get tournamentList => _tournamentListState;
  List<String> get organizerName => _organizerName;

  //setters
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Business logic
  Future<void> refreshTournaments() async {
    await getTournamentList();
  }

  @override
  Future<void> futureToRun() async {
    try {
      await getTournamentList();
    } catch (e) {
      _log.debug(e.toString());
    }

    return Future.value();
  }

  Future<void> getTournamentList() async {
    try {
      List<Map<String, dynamic>> tournamentDataList = await _database
          .getAllByQuery(['status'], [GameStatus.pending.name],
              FirestoreCollections.tournament);
      _log.debug('Tournament data list $tournamentDataList');
      if (tournamentDataList.isNotEmpty) {
        _tournamentListState = tournamentDataList
            .map((tournamentData) => Tournament.fromJson(tournamentData))
            .toList();
        _log.debug(_tournamentListState.toString());

        // get the organizer name by their id and add to the state
        for (int i = 0; i < _tournamentListState.length; i++) {
          String organizerId = _tournamentListState[i].organizerId;
          String organizerName = '';

          Map<String, dynamic>? data = await _database.getByQuery(
              ['userId'], [organizerId], FirestoreCollections.organizer);

          if (data != null) {
            organizerName = Organizer.fromJson(data).organizerName;
          } else {
            organizerName = 'Organizer name not found';
          }
          _organizerName.add(organizerName);
        }
      }
    } catch (e) {
      _log.debug(e.toString());
    }
  }

  // Navigation
  void navigateToTournamentDetail(int index) {
    _router.push(TournamentDetailRoute(
      tournament: _tournamentListState[index],
    ));
  }
}
