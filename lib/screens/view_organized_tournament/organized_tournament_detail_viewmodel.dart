import 'package:esports_battlefield_arena/app/failures.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/seeding/seeding.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:stacked/stacked.dart';

class OrganizedTournamentDetailViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final LogService _log = locator<LogService>();
  final Seeding _seedingAlgorithm = locator<Seeding>();
  final _tournamentService = locator<TournamentService>();

  // State if the view
  bool isParticipantButtonBusy = false;
  bool isLeaderboardButtonBusy = false;

  // Setters
  void updateTournament(Tournament tournament) {
    _tournamentService.updateTournament(tournament);
    notifyListeners();
  }

  void navigateToEditTournament(Tournament tournament) {
    updateTournament(tournament);
    _router.push(const CreateTournamentRoute());
  }

  // business logic
  Future<void> viewAllParticipants(Tournament tournament) async {
    isParticipantButtonBusy = true;
    notifyListeners();
    await _tournamentService.getAllParticipantInformation(tournament);
    _router.push(const ParticipantInformationRoute());
    isParticipantButtonBusy = false;
    notifyListeners();
  }

  Future<bool> createSeeding(Tournament tournament) async {
    try {
      setBusy(true);
      bool sucess = false;
      if (tournament.game == GameType.ApexLegend.name) {
        sucess = await _seedingAlgorithm.seedTeamsForApex(tournament);
      } else {
        sucess =
            await _seedingAlgorithm.seedTeamsForSingleElimination(tournament);
      }

      setBusy(false);
      return sucess;
    } on Failure catch (e) {
      _log.info('${e.message!} \n ${e.location!}');
      setBusy(false);
      return false;
    } catch (e) {
      _log.info(e.toString());
      setBusy(false);
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<void> viewLeaderboard(Tournament tournament) async {
    isLeaderboardButtonBusy = true;
    notifyListeners();
    await _tournamentService.getLeaderboardResult(tournament);
    _router.push(const LeaderboardRoute());
    isLeaderboardButtonBusy = false;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];
}
