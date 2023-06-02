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
import 'package:esports_battlefield_arena/utils/date.dart';
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

  Future<void> apexMatchFinish(int roundIndex, int matchIndex) async {
    List<ApexMatchResult> gameResults =
        apexMatchResult[roundIndex][matchIndex.toString()]!;
    Map<String, dynamic> teamPoint = {};
    // Loop through all result
    for (int result = 0; result < gameResults.length; result++) {
      ApexMatchResult gameResult =
          apexMatchResult[roundIndex][matchIndex.toString()]![result];

      //change the isCompleted to true
      await _database.update(
          gameResult.resultId,
          {
            'isCompleted': true,
          },
          FirestoreCollections.apexMatchResult);

      //get the point for each team for each game
      for (int i = 0; i < gameResult.results.length; i++) {
        //if team is not exist in the teamPoint, add it to the teamPoint

        if (gameResult.results[i]['participantId'].isEmpty) {
          continue;
        }
        if (result == 0) {
          teamPoint.putIfAbsent(gameResult.results[i]['participantId'],
              () => {...gameResult.results[i]});
          teamPoint[gameResult.results[i]['participantId']]['placement'] = 0;
          teamPoint[gameResult.results[i]['participantId']]['seed'] = 0;
          teamPoint[gameResult.results[i]['participantId']]['kills'] = 0;
        } else {
          teamPoint[gameResult.results[i]['participantId']]['points'] =
              int.parse((teamPoint[gameResult.results[i]['participantId']]
                          ['points'] +
                      gameResult.results[i]['points'])
                  .toString());
        }
      }
    }
    //update the match information
    await _database.update(
        gameResults[0].matchId,
        {
          'date': DateHelper.formatDate(DateTime.now()),
          'endTime': DateHelper.formatTime(DateTime.now()),
          'hasCompleted': true,
        },
        FirestoreCollections.apexMatch);

    //Bring the qualified team to the next match
    List<MapEntry<String, dynamic>> sortedEntries = teamPoint.entries.toList();
    sortedEntries
        .sort((a, b) => b.value['points'].compareTo(a.value['points']));
    //qualified team
    if (sortedEntries.length > 10) {
      sortedEntries = sortedEntries.sublist(0, 10);
    }
    List<Map<String, dynamic>> qualifiedTeam =
        sortedEntries.map((entry) => {entry.key: entry.value}).toList();
    String nextMatchId = '';
    log('qualifiedTeam : $qualifiedTeam');
    //Current match
    ApexMatch match = ApexMatch.fromJson(await _database.get(
        gameResults[0].matchId, FirestoreCollections.apexMatch));
    if (match.nextMatchId.isEmpty) {
      log('no next match');
      //final match, no need to update anymore
      _router.pop();
      return;
    }
    nextMatchId = match.nextMatchId;

    // get the next match result
    List<Map<String, dynamic>> nextMatchResultData = await _database
        .getAllByQuery(
            ['matchId'], [nextMatchId], FirestoreCollections.apexMatchResult);
    List<ApexMatchResult> nextMatchResults = nextMatchResultData
        .map((resultData) => ApexMatchResult.fromJson(resultData))
        .toList();

    // To update the list of qualified team to the next match
    ApexMatchResult nextMatchResult =
        ApexMatchResult().copyWith(nextMatchResults.first.toJson());

    log('nextMatchResult : $nextMatchResult');
    log('nextMatchResult : ${nextMatchResult.results.length}');
    log('initial qualifiedTeam length : ${qualifiedTeam.length}');
    while (qualifiedTeam.isNotEmpty) {
      Map<String, dynamic> qTeam = qualifiedTeam.removeLast().values.first;
      log('qualifiedTeam length : ${qualifiedTeam.length}');
      log('qTeam : ${qTeam}');
      log('choice : ${nextMatchResult.results.contains(qTeam)}');
      if (!nextMatchResult.results.contains(qTeam)) {
        for (int team = 0; team < nextMatchResult.results.length; team++) {
          if (nextMatchResult.results[team]['participantId'].isEmpty) {
            qTeam['points'] = 0;
            nextMatchResult.results[team] = qTeam;
            break;
          }
        }
      } else {
        continue;
      }
    }

    // Map<String, dynamic> fakeData = {
    //   'participantId': '',
    //   'points': 0,
    //   'placement': 0,
    //   'seed': 0,
    //   'kills': 0,
    //   'teamName': 'No team'
    // };

    // log('nextMatchResult : ${nextMatchResult.results}');

    //update the next match result
    for (int result = 0; result < nextMatchResults.length; result++) {
      await _database.update(
          nextMatchResults[result].resultId,
          {
            'results': nextMatchResult.results,
            // 'results': List.generate(20, (index) => fakeData),
          },
          FirestoreCollections.apexMatchResult);
    }
    _router.pop();
  }
}
