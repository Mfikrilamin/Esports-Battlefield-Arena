import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/user.dart';
import 'package:esports_battlefield_arena/models/username.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
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

  void viewAllParticipants() {
    _tournamentService.getAllParticipantInformation();
    // _router.push(const ParticipantInformationRoute());
  }

  @override
  // TODO: implement reactiveServices
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];

  Future<Map<String, dynamic>> fetchParticipant(Tournament tournament) async {
    List<TournamentParticipant> _participantList = [];
    List<Map<String, dynamic>> _playerList = [];
    for (String participantId in tournament.currentParticipant) {
      TournamentParticipant participant = TournamentParticipant.fromJson(
        await _database.get(
            participantId, FirestoreCollections.tournamentParticipant),
      );
      _participantList.add(participant);
      for (Username username
          in participant.usernameList.map((e) => Username.fromJson(e))) {
        User user = User.fromJson(
            await _database.get(username.userId, FirestoreCollections.users));
        Player player = Player.fromJson(
            await _database.get(username.userId, FirestoreCollections.player));
        _playerList.add({
          'name': '${player.firstName} ${player.lastName}',
          'username': username.username,
          'country': user.country,
        });
      }
    }
    Map<String, dynamic> participantInformation = {
      'participantList': _participantList,
      'playerList': _playerList
    };
    _log.debug('Participant list: $_participantList');
    return participantInformation;
  }
}
