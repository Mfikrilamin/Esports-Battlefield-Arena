import 'dart:developer';

import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/apex_match.dart';
import 'package:esports_battlefield_arena/models/apex_match_result.dart';
import 'package:esports_battlefield_arena/models/valorant_match.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/game_database/valorant/valorant.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';

import 'package:stacked/stacked.dart';

class LeaderboardViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final Auth _auth = locator<Auth>();
  bool _isOrganizer = false;
  final _tournamentService = locator<TournamentService>();
  final ValorantDatabase _valorantDatabase = locator<ValorantDatabase>();

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

  navigateBackOnEditPage(int roundIndex, int matchIndex, int gameIndex) {
    //reset back the point, kill and placement
    _tournamentService.resetPointKillAndPlacement(
        roundIndex, matchIndex, gameIndex - 1);
    _router.pop();
  }

  updateResultLobbyId(
      int roundIndex, int matchIndex, int gameIndex, String lobbyId) {
    String matchIndexStr = matchIndex.toString();
    if (game == GameType.ApexLegend.name) {
      gameIndex = gameIndex - 1;
      log(lobbyId);
      log('round : $roundIndex, match : $matchIndex, game : $gameIndex');
      apexMatchResult[roundIndex][matchIndexStr]![gameIndex] = ApexMatchResult(
        resultId:
            apexMatchResult[roundIndex][matchIndexStr]![gameIndex].resultId,
        lobbyId: lobbyId,
        matchId: apexMatchResult[roundIndex][matchIndexStr]![gameIndex].matchId,
        gameNumber:
            apexMatchResult[roundIndex][matchIndexStr]![gameIndex].gameNumber,
        completed:
            apexMatchResult[roundIndex][matchIndexStr]![gameIndex].completed,
        results: apexMatchResult[roundIndex][matchIndexStr]![gameIndex].results,
      );
    } else {
      log(lobbyId);
      log('round : $roundIndex, match : $matchIndex, game : $gameIndex');
      valorantMatchResult[roundIndex][matchIndexStr]![gameIndex] =
          ValorantMatchResult(
        resultId:
            valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].resultId,
        lobbyId: lobbyId,
        matchId:
            valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].matchId,
        gameNumber: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .gameNumber,
        teamA: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].teamA,
        teamB: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].teamB,
        winner:
            valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].winner,
        loser: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].loser,
        teamAScore: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .teamAScore,
        teamBScore: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .teamBScore,
        isCompleted: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .isCompleted,
        playerStats: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .playerStats,
      );
    }
  }

  Future<void> submitLobbyId(
      int roundIndex, int matchIndex, int gameIndex) async {
    String matchIndexStr = matchIndex.toString();
    log('round : $roundIndex, match : $matchIndex, game : ${gameIndex}');
    if (game == GameType.ApexLegend.name) {
      gameIndex = gameIndex - 1;
      ApexMatchResult result =
          apexMatchResult[roundIndex][matchIndexStr]![gameIndex];
      await _database.update(result.resultId, {'lobbyId': result.lobbyId},
          FirestoreCollections.apexMatchResult);
      // Fire backend fucntion to create a websocket or get the data from the external database and update in our database
    } else {
      ValorantMatchResult result =
          valorantMatchResult[roundIndex][matchIndexStr]![gameIndex];
      await _database.update(result.resultId, {'lobbyId': result.lobbyId},
          FirestoreCollections.valorantMatchResult);
      // Fire backend fucntion to create a websocket or get the data from the external database and update in our database
    }
  }

  bool isLobbyIdAvailable(int roundIndex, int matchIndex, int gameResultIndex) {
    String matchIndexStr = matchIndex.toString();
    if (game == GameType.ApexLegend.name) {
      gameResultIndex = gameResultIndex - 1;
      return apexMatchResult[roundIndex][matchIndexStr]![gameResultIndex]
          .lobbyId
          .isNotEmpty;
    } else {
      return valorantMatchResult[roundIndex][matchIndexStr]![gameResultIndex]
          .lobbyId
          .isNotEmpty;
    }
  }

  Future<void> resetLobbyId(
      int roundIndex, int matchIndex, int gameIndex) async {
    String matchIndexStr = matchIndex.toString();
    if (game == GameType.ApexLegend.name) {
      gameIndex = gameIndex - 1;
      apexMatchResult[roundIndex][matchIndexStr]![gameIndex] = ApexMatchResult(
        resultId:
            apexMatchResult[roundIndex][matchIndexStr]![gameIndex].resultId,
        lobbyId: '',
        matchId: apexMatchResult[roundIndex][matchIndexStr]![gameIndex].matchId,
        gameNumber:
            apexMatchResult[roundIndex][matchIndexStr]![gameIndex].gameNumber,
        completed:
            apexMatchResult[roundIndex][matchIndexStr]![gameIndex].completed,
        results: apexMatchResult[roundIndex][matchIndexStr]![gameIndex].results,
      );
      ApexMatchResult result =
          apexMatchResult[roundIndex][matchIndexStr]![gameIndex];
      await _database.update(result.resultId, {'lobbyId': result.lobbyId},
          FirestoreCollections.apexMatchResult);
    } else {
      valorantMatchResult[roundIndex][matchIndexStr]![gameIndex] =
          ValorantMatchResult(
        resultId:
            valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].resultId,
        lobbyId: '',
        matchId:
            valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].matchId,
        gameNumber: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .gameNumber,
        teamA: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].teamA,
        teamB: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].teamB,
        winner:
            valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].winner,
        loser: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex].loser,
        teamAScore: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .teamAScore,
        teamBScore: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .teamBScore,
        isCompleted: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .isCompleted,
        playerStats: valorantMatchResult[roundIndex][matchIndexStr]![gameIndex]
            .playerStats,
      );
      ValorantMatchResult result =
          valorantMatchResult[roundIndex][matchIndexStr]![gameIndex];
      await _database.update(result.resultId, {'lobbyId': result.lobbyId},
          FirestoreCollections.valorantMatchResult);
      // Fire backend fucntion to create a websocket or get the data from the external database and update in our database
    }
  }

  void finishLobby(int roundIndex, int matchIndex, int resultIndex) {
    String matchIndexStr = matchIndex.toString();
    if (game == GameType.ApexLegend.name) {
      resultIndex = resultIndex - 1;
      ApexMatchResult result =
          apexMatchResult[roundIndex][matchIndexStr]![resultIndex];
    } else {
      ValorantMatchResult result =
          valorantMatchResult[roundIndex][matchIndexStr]![resultIndex];

      _valorantDatabase.getMatchSummaryAndUpdateLeaderboard(
          valorantMatches[roundIndex][matchIndex], result);
    }
  }

  void navigateToEditLeaderboardPage(
      int roundIndex, int matchIndex, int gameNumber) {
    _router.popAndPush(EditLeaderboardRoute(
        roundIndex: roundIndex,
        matchIndex: matchIndex,
        matchResultIndex: gameNumber));
  }

  updatePlacement(int roundIndex, int matchIndex, int matchResultIndex,
      int index, String value) {
    log('round: $roundIndex match: $matchIndex  gameIndex: $matchResultIndex  teamIndex: $index  value: $value');

    if (value.isEmpty) {
      value = '0';
    } else {
      int placement = int.parse(value);
      //check if the value is valid or not
      if (placement < 0 && placement > 20) {
        return;
      }

      if (game == GameType.ApexLegend.name) {
        apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex]
            .results[index]['placement'] = placement;
        log('placement : ${apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex].results[index]['placement']}');
      } else {
        //valorant
        // handle later
      }
    }
  }

  updateKill(int roundIndex, int matchIndex, int matchResultIndex, int index,
      String value) {
    log('round: $roundIndex match: $matchIndex  gameIndex: $matchResultIndex  teamIndex: $index  value: $value');
    if (value.isEmpty) {
      value = '0';
    } else {
      int kills = int.parse(value);

      if (game == GameType.ApexLegend.name) {
        apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex]
            .results[index]['kills'] = kills * 1;
        log('kills : ${apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex].results[index]['kills']}');
      } else {
        //valorant
        // handle later
      }
    }
  }

  int calculatePlacementPoint(int placement) {
    int point = 0;
    switch (placement) {
      case 1:
        point = 12;
        break;
      case 2:
        point = 9;
        break;
      case 3:
        point = 7;
        break;
      case 4:
        point = 5;
        break;
      case 5:
        point = 4;
        break;
      case 6:
        point = 3;
        break;
      case 7:
        point = 3;
        break;
      case 8:
        point = 2;
        break;
      case 9:
        point = 2;
        break;
      case 10:
        point = 2;
        break;
      case 11:
        point = 1;
        break;
      case 12:
        point = 1;
        break;
      case 13:
        point = 1;
        break;
      case 14:
        point = 1;
        break;
      case 15:
        point = 1;
        break;
      default:
        point = 0;
        break;
    }
    return point;
  }

  Future<void> upateApexLeaderboard(
      {required int roundIndex,
      required int matchIndex,
      required int matchResultIndex}) async {
    matchResultIndex = matchResultIndex - 1;
    List<Map<String, dynamic>> teamsResultData = apexMatchResult[roundIndex]
            [matchIndex.toString()]![matchResultIndex]
        .results;
    log('teamResultData : $teamsResultData');
    // Loop to calculate the points for each team
    for (int resultTeamIndex = 0;
        resultTeamIndex < teamsResultData.length;
        resultTeamIndex++) {
      int point = 0;
      Map<String, dynamic> teamResultData = teamsResultData[resultTeamIndex];
      point += calculatePlacementPoint(teamResultData['placement']);
      point = point + int.parse(teamResultData['kills'].toString());
      apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex]
          .results[resultTeamIndex]['points'] = point;
    }

    // Sort the teams based on the points
    List<Map<String, dynamic>> sortedTeamsResultData =
        List.from(teamsResultData);
    sortedTeamsResultData.sort((a, b) => b['points'].compareTo(a['points']));

    Map<String, int> sortedTeamPlacement = {};

    for (int resultTeamIndex = 0;
        resultTeamIndex < sortedTeamsResultData.length;
        resultTeamIndex++) {
      sortedTeamPlacement.putIfAbsent(
          sortedTeamsResultData[resultTeamIndex]['participantId'],
          () => (resultTeamIndex + 1));
    }

    for (int resultTeamIndex = 0;
        resultTeamIndex < sortedTeamsResultData.length;
        resultTeamIndex++) {
      //assign seeding for each team based on the sorted list
      // the key is the participantId
      // the value is the seeding
      teamsResultData[resultTeamIndex]['seed'] = sortedTeamPlacement[
          teamsResultData[resultTeamIndex]['participantId']];
    }
    await _database.update(
        apexMatchResult[roundIndex][matchIndex.toString()]![matchResultIndex]
            .resultId,
        {
          'results': teamsResultData,
        },
        FirestoreCollections.apexMatchResult);
    notifyListeners();
    _router.pop();
  }

  Future<void> apexMatchGameFinish(
      int roundIndex, int matchIndex, int gameNumber) async {
    gameNumber = gameNumber - 1;
    ApexMatchResult gameResultData =
        apexMatchResult[roundIndex][matchIndex.toString()]![gameNumber];

    //change the isCompleted to true
    await _database.update(
        gameResultData.resultId,
        {
          'isCompleted': true,
        },
        FirestoreCollections.apexMatchResult);

    List<Map<String, dynamic>> sortedTeamsResultData =
        List.from(gameResultData.results);
    sortedTeamsResultData.sort((a, b) => b['points'].compareTo(a['points']));

    List<Map<String, dynamic>> qualifiedTeam = sortedTeamsResultData.sublist(
        0, (sortedTeamsResultData.length * 0.5).round());
    // get nextMatchId
    String nextMatchId = '';

    //Current match
    ApexMatch match = ApexMatch.fromJson(await _database.get(
        gameResultData.matchId, FirestoreCollections.apexMatch));
    nextMatchId = match.nextMatchId;

    // get the next match result
    List<Map<String, dynamic>> nextMatchResultData = await _database
        .getAllByQuery(
            ['matchId'], [nextMatchId], FirestoreCollections.apexMatchResult);
    List<ApexMatchResult> nextMatchResults = nextMatchResultData
        .map((resultData) => ApexMatchResult.fromJson(resultData))
        .toList();
    for (int result = 0; result < nextMatchResults.length; result++) {
      //check in the resultList if there is team or not
      if (nextMatchResults[result]
          .results
          .first['participantId']
          .isNotEmpty()) {
        // meaning there is a team in the first 10 of the result list
        // So we append the qualified team at the last of 10 team in the resultList
        nextMatchResults[result].results.replaceRange(10, 20, qualifiedTeam);
      } else {
        // meaning there is no team in the first 10 of the result list
        // So we append the qualified team at the first of 10 team in the resultList
        nextMatchResults[result].results.replaceRange(0, 10, qualifiedTeam);
      }
    }
  }
}
