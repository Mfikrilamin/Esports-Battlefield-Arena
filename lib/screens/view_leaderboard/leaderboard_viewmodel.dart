import 'dart:developer';

import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/apex_match.dart';
import 'package:esports_battlefield_arena/models/apex_match_result.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/valorant_match.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';

import 'package:stacked/stacked.dart';

class LeaderboardViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final Auth _auth = locator<Auth>();
  bool _isOrganizer = false;
  final _tournamentService = locator<TournamentService>();

  // getter
  bool get isOrganizer => _isOrganizer;
  String get game => _tournamentService.leaderboardGame;
  List<bool> get roundExpanded => _tournamentService.roundExpanded;
  List<List<bool>> get matchExpanded => _tournamentService.matchExpanded;
  List<List<int>> get carousellCurrentIndex =>
      _tournamentService.carousellSelectedIndex;
  List<List<ApexMatch>> get apexMatches => _tournamentService.apexMatches;
  List<List<ValorantMatch>> get valorantMatches =>
      _tournamentService.valorantMatches;
  // The first list is the round,
  // For each round, it contains a map of matches id and list of results
  // Match id here is using the index due too using list view builder
  // List of result contain all the result for that particular match
  List<Map<String, List<ApexMatchResult>>> get apexMatchResult =>
      _tournamentService.apexResults;
  List<Map<String, List<ValorantMatchResult>>> get valorantMatchResult =>
      _tournamentService.valorantResults;

  Future<void> refreshLeadboard() {
    return Future.value();
  }

  void updateCarousellSelectedIndex(int round, int match, int index) {
    _tournamentService.updateCarousellSelectedIndex(round, match, index);
    notifyListeners();
  }

  String getNextRoundMatch(int roundIndex, int matchIndex) {
    if (game == GameType.Valorant.name) {
      for (int round = 0; round < valorantMatches.length; round++) {
        for (int match = 0; match < valorantMatches[round].length; match++) {
          if (valorantMatches[round][match].matchId ==
              valorantMatches[roundIndex][matchIndex].nextMatchId) {
            return '[Round ${round + 1}, match ${match + 1}]';
          }
        }
      }
    } else {
      for (int round = 0; round < apexMatches.length; round++) {
        for (int match = 0; match < apexMatches[round].length; match++) {
          if (apexMatches[round][match].matchId ==
              apexMatches[roundIndex][matchIndex].nextMatchId) {
            return '[Round ${round + 1}, match ${match + 1}]';
          }
        }
      }
    }
    return '';
  }

  void updateRoundPanel(int roundIndex, bool isExpanded) {
    log('roundIndex: ${roundIndex + 1}, isExpanded: $isExpanded');
    _tournamentService.roundExpanded[roundIndex] = !isExpanded;
    notifyListeners();
  }

  void updateMatchPanel(int roundIndex, int matchIndex, bool isExpanded) {
    log('roundIndex: ${roundIndex + 1}  Match index:${matchIndex + 1} , isExpanded: $isExpanded');
    _tournamentService.matchExpanded[roundIndex][matchIndex] = !isExpanded;
    notifyListeners();
  }

  bool isResultAvailable(int roundIndex, int matchIndex) {
    if (_tournamentService.leaderboardGame == GameType.ApexLegend.name) {
      return _tournamentService
          .apexResults[roundIndex][matchIndex.toString()]!.isNotEmpty;
    } else if (_tournamentService.leaderboardGame == GameType.Valorant.name) {
      log('isResult available : ${_tournamentService.valorantResults[roundIndex][matchIndex.toString()]!.isNotEmpty}');
      log('isResult  : ${_tournamentService.valorantResults[roundIndex][matchIndex.toString()]!.length}');
      return _tournamentService
          .valorantResults[roundIndex][matchIndex.toString()]!.isNotEmpty;
    }
    return false;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];

  navigateBack() {
    _tournamentService.disposeMatchAndResultInformation();
    _router.pop();
  }
}
