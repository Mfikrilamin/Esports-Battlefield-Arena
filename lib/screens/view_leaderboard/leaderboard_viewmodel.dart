import 'dart:developer';

import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/apex_match.dart';
import 'package:esports_battlefield_arena/models/apex_match_result.dart';
import 'package:esports_battlefield_arena/models/user.dart';
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
  final ValorantDatabase _valorantDatabase = locator<ValorantDatabase>();
  final _tournamentService = locator<TournamentService>();

  // State of the view
  bool _isOrganizer = false;
  bool _showDialogErrorMessage = false;

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
  bool get showDialogErrorMessage => _showDialogErrorMessage;
  // The first list is the round,
  // For each round, it contains a map of matches id and list of results
  // Match id here is using the index due too using list view builder
  // List of result contain all the result for that particular match
  List<Map<String, List<ApexMatchResult>>> get apexMatchResult =>
      _tournamentService.apexResults;
  List<Map<String, List<ValorantMatchResult>>> get valorantMatchResult =>
      _tournamentService.valorantResults;

  // setters
  void updateShowDialogErrorMessageState(bool value) {
    _showDialogErrorMessage = value;
    notifyListeners();
  }

  void updateCarousellSelectedIndex(int round, int match, int index) {
    _tournamentService.updateCarousellSelectedIndex(round, match, index);
    notifyListeners();
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

  // business logic
  checkCurrentUserRole() async {
    String? id = _auth.currentUser();

    if (id != null) {
      User user =
          User.fromJson(await _database.get(id, FirestoreCollections.users));
      if (user.role == UserRole.organizer.name) {
        _isOrganizer = true;
      } else {
        _isOrganizer = false;
      }
    }
    notifyListeners();
  }

  Future<void> refreshLeadboard() {
    return Future.value();
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

  Future<void> finishLobby(
      int roundIndex, int matchIndex, int resultIndex) async {
    String matchIndexStr = matchIndex.toString();
    if (game == GameType.ApexLegend.name) {
      resultIndex = resultIndex - 1;
      ApexMatchResult result =
          apexMatchResult[roundIndex][matchIndexStr]![resultIndex];
    } else {
      ValorantMatchResult result =
          valorantMatchResult[roundIndex][matchIndexStr]![resultIndex];

      String matchWinner =
          await _valorantDatabase.getMatchSummaryAndUpdateLeaderboard(
              valorantMatches[roundIndex][matchIndex], result);
      if (matchWinner == "unsucessful") {
        return;
      } else {
        String updatedPoint = '';
        if (matchWinner == valorantMatches[roundIndex][matchIndex].teamA) {
          updatedPoint = valorantMatches[roundIndex][matchIndex].teamAScore;
          if (updatedPoint.isEmpty) {
            updatedPoint = '0';
          }
          updatedPoint = (int.parse(updatedPoint) + 1).toString();
          ValorantMatch valorantMatch = ValorantMatch(
            tournamentId: valorantMatches[roundIndex][matchIndex].tournamentId,
            matchId: valorantMatches[roundIndex][matchIndex].matchId,
            nextMatchId: valorantMatches[roundIndex][matchIndex].nextMatchId,
            game: valorantMatches[roundIndex][matchIndex].game,
            round: valorantMatches[roundIndex][matchIndex].round,
            match: valorantMatches[roundIndex][matchIndex].match,
            teamA: valorantMatches[roundIndex][matchIndex].teamA,
            teamB: valorantMatches[roundIndex][matchIndex].teamB,
            winner: valorantMatches[roundIndex][matchIndex].winner,
            loser: valorantMatches[roundIndex][matchIndex].loser,
            teamAScore: updatedPoint,
            teamBScore: valorantMatches[roundIndex][matchIndex].teamBScore,
            date: valorantMatches[roundIndex][matchIndex].date,
            startTime: valorantMatches[roundIndex][matchIndex].startTime,
            endTime: valorantMatches[roundIndex][matchIndex].endTime,
            hasCompleted: valorantMatches[roundIndex][matchIndex].hasCompleted,
            resultList: valorantMatches[roundIndex][matchIndex].resultList,
          );
          valorantMatches[roundIndex][matchIndex] = valorantMatch;
        } else {
          updatedPoint = valorantMatches[roundIndex][matchIndex].teamBScore;
          if (updatedPoint.isEmpty) {
            updatedPoint = '0';
          }
          updatedPoint = (int.parse(updatedPoint) + 1).toString();
          ValorantMatch valorantMatch = ValorantMatch(
            tournamentId: valorantMatches[roundIndex][matchIndex].tournamentId,
            matchId: valorantMatches[roundIndex][matchIndex].matchId,
            nextMatchId: valorantMatches[roundIndex][matchIndex].nextMatchId,
            game: valorantMatches[roundIndex][matchIndex].game,
            round: valorantMatches[roundIndex][matchIndex].round,
            match: valorantMatches[roundIndex][matchIndex].match,
            teamA: valorantMatches[roundIndex][matchIndex].teamA,
            teamB: valorantMatches[roundIndex][matchIndex].teamB,
            winner: valorantMatches[roundIndex][matchIndex].winner,
            loser: valorantMatches[roundIndex][matchIndex].loser,
            teamAScore: valorantMatches[roundIndex][matchIndex].teamAScore,
            teamBScore: updatedPoint,
            date: valorantMatches[roundIndex][matchIndex].date,
            startTime: valorantMatches[roundIndex][matchIndex].startTime,
            endTime: valorantMatches[roundIndex][matchIndex].endTime,
            hasCompleted: valorantMatches[roundIndex][matchIndex].hasCompleted,
            resultList: valorantMatches[roundIndex][matchIndex].resultList,
          );
          valorantMatches[roundIndex][matchIndex] = valorantMatch;
        }
        notifyListeners();
        await _database.update(
            valorantMatches[roundIndex][matchIndex].matchId,
            valorantMatches[roundIndex][matchIndex].toJson(),
            FirestoreCollections.valorantMatch);
      }
    }
  }

  // Function used in upateApexLeaderboard
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

  // Function used in upateApexLeaderboard
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

  // Function used in upateApexLeaderboard
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

  Future<void> matchFinish(int roundIndex, int matchIndex) {
    if (game == GameType.ApexLegend.name) {
      apexMatchFinish(roundIndex, matchIndex);
    } else {
      valorantMatchFinish(roundIndex, matchIndex);
    }
    return Future.value();
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

  Future<void> valorantMatchFinish(int roundIndex, int matchIndex) async {
    log('valorantMatchFinish : $roundIndex, $matchIndex');
    String teamA = valorantMatches[roundIndex][matchIndex].teamA;
    String teamB = valorantMatches[roundIndex][matchIndex].teamB;
    if (roundIndex > 0) {
      if (teamA.isEmpty && teamB.isEmpty) {
        _showDialogErrorMessage = true;
        notifyListeners();
        _router.pop();
        return;
      }
    }
    String teamAName =
        valorantMatchResult[roundIndex][matchIndex.toString()]![0].teamA;
    String teamBName =
        valorantMatchResult[roundIndex][matchIndex.toString()]![0].teamB;
    String teamAScore = valorantMatches[roundIndex][matchIndex].teamAScore;
    String teamBScore = valorantMatches[roundIndex][matchIndex].teamBScore;
    int teamAScoreInt = int.parse(teamAScore);
    int teamBScoreInt = int.parse(teamBScore);
    bool teamAwinning = teamAScoreInt > teamBScoreInt ? true : false;

    ValorantMatch valorantMatch = ValorantMatch(
      tournamentId: valorantMatches[roundIndex][matchIndex].tournamentId,
      matchId: valorantMatches[roundIndex][matchIndex].matchId,
      nextMatchId: valorantMatches[roundIndex][matchIndex].nextMatchId,
      game: valorantMatches[roundIndex][matchIndex].game,
      round: valorantMatches[roundIndex][matchIndex].round,
      match: valorantMatches[roundIndex][matchIndex].match,
      teamA: valorantMatches[roundIndex][matchIndex].teamA,
      teamB: valorantMatches[roundIndex][matchIndex].teamB,
      winner: teamAwinning ? teamA : teamB,
      loser: teamAwinning ? teamB : teamA,
      teamAScore: valorantMatches[roundIndex][matchIndex].teamAScore,
      teamBScore: valorantMatches[roundIndex][matchIndex].teamBScore,
      date: DateHelper.formatDate(DateTime.now()),
      startTime: valorantMatches[roundIndex][matchIndex].startTime,
      endTime: DateHelper.formatTime(DateTime.now()),
      hasCompleted: true,
      resultList: valorantMatches[roundIndex][matchIndex].resultList,
    );
    await _database.update(valorantMatches[roundIndex][matchIndex].matchId,
        valorantMatch.toJson(), FirestoreCollections.valorantMatch);
    valorantMatches[roundIndex][matchIndex] = valorantMatch;
    notifyListeners();

    String nextMatchId = valorantMatches[roundIndex][matchIndex].nextMatchId;
    //update winning team to the next round
    if (nextMatchId.isNotEmpty) {
      int nextRoundTotalMatch = valorantMatches[roundIndex + 1].length;
      for (int nextMatchIndex = 0;
          nextMatchIndex < nextRoundTotalMatch;
          nextMatchIndex++) {
        ValorantMatch nextMatch =
            valorantMatches[roundIndex + 1][nextMatchIndex];
        if (nextMatch.matchId == nextMatchId) {
          if (nextMatch.teamA.isEmpty) {
            //update into team A
            ValorantMatch nextValorantMatch = ValorantMatch(
              tournamentId: nextMatch.tournamentId,
              matchId: nextMatch.matchId,
              nextMatchId: nextMatch.nextMatchId,
              game: nextMatch.game,
              round: nextMatch.round,
              match: nextMatch.match,
              teamA: teamAwinning ? teamA : teamB,
              teamB: nextMatch.teamB,
              winner: nextMatch.winner,
              loser: nextMatch.loser,
              teamAScore: nextMatch.teamAScore,
              teamBScore: nextMatch.teamBScore,
              date: nextMatch.date,
              startTime: nextMatch.startTime,
              endTime: nextMatch.endTime,
              hasCompleted: nextMatch.hasCompleted,
              resultList: nextMatch.resultList,
            );
            await _database.update(nextMatch.matchId,
                nextValorantMatch.toJson(), FirestoreCollections.valorantMatch);
            valorantMatches[roundIndex + 1][nextMatchIndex] = nextValorantMatch;

            //update the result as well
            List<ValorantMatchResult> nextMatchResultList =
                valorantMatchResult[roundIndex + 1][nextMatchIndex.toString()]!;
            for (int resultIndex = 0;
                resultIndex < nextMatchResultList.length;
                resultIndex++) {
              ValorantMatchResult nextMatchResult = ValorantMatchResult(
                resultId: nextMatchResultList[resultIndex].resultId,
                matchId: nextMatchResultList[resultIndex].matchId,
                lobbyId: nextMatchResultList[resultIndex].lobbyId,
                gameNumber: nextMatchResultList[resultIndex].gameNumber,
                teamA: teamAName,
                teamB: nextMatchResultList[resultIndex].teamB,
                winner: nextMatchResultList[resultIndex].winner,
                loser: nextMatchResultList[resultIndex].loser,
                teamAScore: nextMatchResultList[resultIndex].teamAScore,
                teamBScore: nextMatchResultList[resultIndex].teamBScore,
                isCompleted: nextMatchResultList[resultIndex].isCompleted,
                playerStats: nextMatchResultList[resultIndex].playerStats,
              );
              await _database.update(
                  nextMatchResultList[resultIndex].resultId,
                  nextMatchResult.toJson(),
                  FirestoreCollections.valorantMatchResult);
              nextMatchResultList[resultIndex] = nextMatchResult;
            }
          } else if (nextMatch.teamB.isEmpty) {
            //update into team B
            ValorantMatch nextValorantMatch = ValorantMatch(
              tournamentId: nextMatch.tournamentId,
              matchId: nextMatch.matchId,
              nextMatchId: nextMatch.nextMatchId,
              game: nextMatch.game,
              round: nextMatch.round,
              match: nextMatch.match,
              teamA: nextMatch.teamA,
              teamB: teamAwinning ? teamA : teamB,
              winner: nextMatch.winner,
              loser: nextMatch.loser,
              teamAScore: nextMatch.teamAScore,
              teamBScore: nextMatch.teamBScore,
              date: nextMatch.date,
              startTime: nextMatch.startTime,
              endTime: nextMatch.endTime,
              hasCompleted: nextMatch.hasCompleted,
              resultList: nextMatch.resultList,
            );
            await _database.update(nextMatch.matchId,
                nextValorantMatch.toJson(), FirestoreCollections.valorantMatch);
            valorantMatches[roundIndex + 1][nextMatchIndex] = nextValorantMatch;

            //update the result as well
            List<ValorantMatchResult> nextMatchResultList =
                valorantMatchResult[roundIndex + 1][nextMatchIndex.toString()]!;
            for (int resultIndex = 0;
                resultIndex < nextMatchResultList.length;
                resultIndex++) {
              ValorantMatchResult nextMatchResult = ValorantMatchResult(
                resultId: nextMatchResultList[resultIndex].resultId,
                matchId: nextMatchResultList[resultIndex].matchId,
                lobbyId: nextMatchResultList[resultIndex].lobbyId,
                gameNumber: nextMatchResultList[resultIndex].gameNumber,
                teamA: nextMatchResultList[resultIndex].teamA,
                teamB: teamBName,
                winner: nextMatchResultList[resultIndex].winner,
                loser: nextMatchResultList[resultIndex].loser,
                teamAScore: nextMatchResultList[resultIndex].teamAScore,
                teamBScore: nextMatchResultList[resultIndex].teamBScore,
                isCompleted: nextMatchResultList[resultIndex].isCompleted,
                playerStats: nextMatchResultList[resultIndex].playerStats,
              );
              await _database.update(
                  nextMatchResultList[resultIndex].resultId,
                  nextMatchResult.toJson(),
                  FirestoreCollections.valorantMatchResult);
              nextMatchResultList[resultIndex] = nextMatchResult;
            }
          } else {
            break;
          }
          break;
        }
      }
    }
    notifyListeners();
    _router.pop();
  }

  // Navigation
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

  void navigateToEditLeaderboardPage(
      int roundIndex, int matchIndex, int gameNumber) {
    _router.popAndPush(EditLeaderboardRoute(
        roundIndex: roundIndex,
        matchIndex: matchIndex,
        matchResultIndex: gameNumber));
  }
}
