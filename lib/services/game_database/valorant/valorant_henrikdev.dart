import 'dart:convert';

import 'package:esports_battlefield_arena/app/failures.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/valorant_match.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/game_database/valorant/valorant.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:http/http.dart' as http;

class ValorantHenrikdevAPI extends ValorantDatabase {
  final LogService _log = locator<LogService>();
  final Database _database = locator<Database>();
  @override
  Future<Map<String, dynamic>> verifyPlayer(
      String userName, String playerTag) async {
    try {
      //Make post request to our cloud function
      var response = await http.get(
        Uri.parse(
            'https://api.henrikdev.xyz/valorant/v1/account/$userName/$playerTag'),
      );

      // if (response.statusCode != 200) {
      //   throw Failure('Failed to verify user',
      //       message: response.body.toString(),
      //       location: 'StripePaymentService.createPaymentIntent');
      // }
      _log.debug('Response is:---> ${response.body}');
      Map<String, dynamic> returnData = {};
      Map<String, dynamic> _response = json.decode(response.body);
      if (_response['status'] != 200) {
        returnData.putIfAbsent('status', () => false);
        returnData.putIfAbsent(
            'message', () => _response['errors'][0]['message']);
        returnData.putIfAbsent('data', () => []);
      } else {
        var playerInformation = {
          'puuid': _response['data']['puuid'],
          'username': _response['data']['name'],
          'tagline': _response['data']['tag'],
          'region': _response['data']['region'],
        };
        returnData.putIfAbsent('status', () => true);
        returnData.putIfAbsent('message', () => 'Valorant player found');
        returnData.putIfAbsent('data', () => playerInformation);
      }

      return returnData;
    } catch (err) {
      throw Failure('Something went wrong',
          message: err.toString(),
          location: 'ValorantHenrikdevAPI.verifyPlayer');
    }
  }

  @override
  Future<void> getMatchSummaryAndUpdateLeaderboard(
      ValorantMatch match, ValorantMatchResult result) async {
    try {
      //get player PUUID from tournamentParticipantInformation
      String teamAId = match.teamA;
      String teamBId = match.teamB;
      //select either player from both of this team
      TournamentParticipant teamA = TournamentParticipant.fromJson(
          await _database.get(
              teamAId, FirestoreCollections.tournamentParticipant));
      TournamentParticipant teamB = TournamentParticipant.fromJson(
          await _database.get(
              teamBId, FirestoreCollections.tournamentParticipant));
      List<dynamic> usernameList = [...teamA.usernameList];
      usernameList.addAll(teamB.usernameList);
      List<String> teamAPuuidList = teamA.usernameList
          .map((username) => username['usernameId'].toString())
          .toList();
      List<String> teamBPuuidList = teamB.usernameList
          .map((username) => username['usernameId'].toString())
          .toList();
      List<String> puuidList = usernameList
          .map((username) => username['usernameId'].toString())
          .toList();

      //all players username information
      for (int puuidIndex = 0; puuidIndex < puuidList.length; puuidIndex++) {
        String PPUID = teamA.usernameList[puuidIndex]['usernameId'];
        //Make post request to our cloud function
        var response = await http.get(
          Uri.parse(
              'https://api.henrikdev.xyz/valorant/v3/by-puuid/matches/ap/$PPUID'),
        );

        if (response.statusCode != 200) {
          throw Failure('Something wrong when getting match summary',
              message: response.body.toString(),
              location:
                  'ValorantHenrikdevAPI.getMatchSummaryAndUpdateLeaderboard');
        }
        _log.debug('Response is:---> ${response.body}');

        Map<String, dynamic> _response = json.decode(response.body);
        if (_response['status'] != 200) {
          //When there is an error in the response status, we try to query again using other PPUID
          continue;
        } else {
          if (_response['status'].length == 0) {
            //When there is an error in the response status, we try to query again using other PPUID
            continue;
          } else {
            bool isCorrectMatchSummary = true;
            // If received data only we check if it the correct match summary
            int totalPlayer =
                _response['data']['players']['all_players'].length;
            for (int playerInData = 0;
                playerInData < totalPlayer;
                playerInData++) {
              String puuid = _response['data']['players']['all_players']
                  [puuidIndex]['puuid'];
              //make comparison with participant PUUID to ensure that this is the correct match summary
              for (int i = 0; i < puuidList.length; i++) {
                if (puuidList[i] != puuid) {
                  //there is at least one the username is not match
                  _log.debug('Not the correct match summary');
                  isCorrectMatchSummary = false;
                  break;
                }
              }
            }
            if (!isCorrectMatchSummary) {
              continue;
            } else {
              // if this is the correct match summary, we update the leaderboard
              // Identify the red and blue team
              Map<String, dynamic> redTeam =
                  _response['data']['players']['red'][0];
              // Map<String, dynamic> blueTeam =
              //     _response['data']['players']['blue'][0];

              for (int i = 0; i < teamAPuuidList.length; i++) {
                if (redTeam.keys.contains(teamAPuuidList[i])) {
                  //meaning teamA is a red team
                  // teamB is a blue team
                  Map<String, dynamic> redTeamResult =
                      _response['data']['teams']['red'];
                  bool hasWon = redTeamResult['has_won'];
                  int roundWon = redTeamResult['rounds_won'];
                  int roundLost = redTeamResult['rounds_lost'];

                  // Update the leaderboard
                  await _database.update(
                      result.resultId,
                      {
                        'teamAScore':
                            hasWon ? roundWon.toString() : roundLost.toString(),
                        'teamBScore':
                            hasWon ? roundLost.toString() : roundWon.toString(),
                        'winner': hasWon ? result.teamA : result.teamB,
                        'loser': hasWon ? result.teamB : result.teamA,
                        'isCompleted': true,
                      },
                      FirestoreCollections.valorantMatchResult);
                  //update the match score
                  if (hasWon) {
                    await _database.update(
                        match.matchId,
                        {
                          'teamAScore':
                              (int.parse(match.teamAScore) + 1).toString(),
                        },
                        FirestoreCollections.valorantMatch);
                  } else {
                    await _database.update(
                        match.matchId,
                        {
                          'teamBScore':
                              (int.parse(match.teamBScore) + 1).toString(),
                        },
                        FirestoreCollections.valorantMatch);
                  }
                  return;
                }
              }
              // Else if safe to assumme that teamB is a red team
              // teamA is a blue team
              // Update the leaderboard
              Map<String, dynamic> redTeamResult =
                  _response['data']['teams']['red'];
              bool hasWon = redTeamResult['has_won'];
              int roundWon = redTeamResult['rounds_won'];
              int roundLost = redTeamResult['rounds_lost'];

              // Update the leaderboard
              await _database.update(
                  result.resultId,
                  {
                    'teamAScore':
                        hasWon ? roundLost.toString() : roundWon.toString(),
                    'teamBScore':
                        hasWon ? roundWon.toString() : roundLost.toString(),
                    'winner': hasWon ? result.teamB : result.teamA,
                    'loser': hasWon ? result.teamA : result.teamB,
                    'isCompleted': true,
                  },
                  FirestoreCollections.valorantMatchResult);
              return;
            }
          }
        }
      }
    } catch (err) {
      throw Failure('Something went wrong',
          message: err.toString(),
          location: 'ValorantHenrikdevAPI.getMatchSummaryAndUpdateLeaderboard');
    }
  }
}
