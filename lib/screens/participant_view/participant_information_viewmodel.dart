import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/service.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:stacked/stacked.dart';

class ParticipantInformationViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final log = locator<LogService>();
  final Auth _auth = locator<Auth>();
  final LogService _log = locator<LogService>();
  final _tournamentService = locator<TournamentService>();

  //getter
  List<TournamentParticipant> get participantList =>
      _tournamentService.participantsInformation;
  List<List<Player>> get playerList => _tournamentService.players;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];

  Future<void> refreshParticipant() {
    _tournamentService.refreshParticipantInformation();
    return Future.value();
  }

  void navigateBack() {
    _tournamentService.disposeParticipantInformation();
    _router.pop();
  }
}
