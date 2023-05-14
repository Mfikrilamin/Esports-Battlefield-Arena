import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/components/widgets/custom_page_route_builder.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/tournament_details/tournament_details_view.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class PlayerHomeViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final log = locator<LogService>();
  final Auth _auth = locator<Auth>();
  final LogService _log = locator<LogService>();

  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  //Tournament card
  int _selectedIndex = 0;
  bool _isExpanded = false;

  List<Tournament> _tournamentListState = [];

  //getters
  int get selectedIndex => _selectedIndex;
  bool get isExpanded => _isExpanded;
  List<Tournament> get tournamentList => _tournamentListState;

  //setters
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void navigateToTournamentDetail(int index) {
    _router
        .push(TournamentDetailRoute(tournament: _tournamentListState[index]));
  }

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
      List<Map<String, dynamic>>? tournamentDataList = await _database
          .getAllByQuery(['status'], [GameStatus.pending.name],
              FirestoreCollections.tournament);
      _log.debug('Tournament data list $tournamentDataList');
      if (tournamentDataList.isNotEmpty) {
        _tournamentListState = tournamentDataList
            .map((tournamentData) => Tournament.fromJson(tournamentData))
            .toList();
        _log.debug(_tournamentListState.toString());
      }
      return Future.value();
    } catch (e) {
      _log.debug(e.toString());
    }
  }
}
