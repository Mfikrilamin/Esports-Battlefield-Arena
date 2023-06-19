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
  Future<String> getMatchSummaryAndUpdateLeaderboard(
      ValorantMatch match, ValorantMatchResult result) async {
    try {
      //get player PUUID from tournamentParticipantInformation
      String teamAId = match.teamA;
      String teamBId = match.teamB;
      //no team
      if ((teamAId == 'No team' && teamBId == 'No team') ||
          (teamAId.isEmpty && teamBId.isEmpty)) {
        return 'unsucessful';
      }
      // if either of the team is bye, then auto win the match
      if (teamAId == 'No team') {
        // Update the leaderboard
        await _database.update(
            result.resultId,
            {
              'teamAScore': '0',
              'teamBScore': '13',
              'winner': teamBId,
              'loser': 'No team',
              'isCompleted': true,
            },
            FirestoreCollections.valorantMatchResult);
        return teamBId;
      }
      if (teamBId == 'No team') {
        await _database.update(
            result.resultId,
            {
              'teamAScore': '13',
              'teamBScore': '0',
              'winner': teamAId,
              'loser': 'No team',
              'isCompleted': true,
            },
            FirestoreCollections.valorantMatchResult);
        return teamAId;
      }

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
        String PPUID = puuidList[puuidIndex];
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
            int index = 0;
            // If received data only we check if it the correct match summary
            for (int totalMatchFromTheQueryIndex = 0;
                totalMatchFromTheQueryIndex < _response['data'].length;
                totalMatchFromTheQueryIndex++) {
              if (_response['data'][totalMatchFromTheQueryIndex]['metadata']
                      ['mode'] !=
                  'Custom Game') {
                continue;
              } else {
                int totalPlayer = _response['data'][totalMatchFromTheQueryIndex]
                        ['players']['all_players']
                    .length;
                for (int playerInData = 0;
                    playerInData < totalPlayer;
                    playerInData++) {
                  String puuid = _response['data'][totalMatchFromTheQueryIndex]
                      ['players']['all_players'][puuidIndex]['puuid'];
                  if (!puuidList.contains(puuid)) {
                    //there is at least one the username is not match
                    _log.debug('Not the correct match summary');
                    isCorrectMatchSummary = false;
                    break;
                  }
                }
                index = totalMatchFromTheQueryIndex;
              }
            }

            if (!isCorrectMatchSummary) {
              continue;
            } else {
              // if this is the correct match summary, we update the leaderboard
              // Identify the red and blue team
              Map<String, dynamic> playerInRedTeam =
                  _response['data'][index]['players']['red'][0];
              // Map<String, dynamic> blueTeam =
              //     _response['data']['players']['blue'][0];

              for (int i = 0; i < teamAPuuidList.length; i++) {
                if (playerInRedTeam['puuid'] == teamAPuuidList[i]) {
                  //meaning teamA is a red team
                  // teamB is a blue team
                  Map<String, dynamic> redTeamResult =
                      _response['data'][index]['teams']['red'];
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
                  // //update the match score
                  // if (hasWon) {
                  //   await _database.update(
                  //       match.matchId,
                  //       {
                  //         'teamAScore':
                  //             (int.parse(match.teamAScore) + 1).toString(),
                  //       },
                  //       FirestoreCollections.valorantMatch);
                  // } else {
                  //   await _database.update(
                  //       match.matchId,
                  //       {
                  //         'teamBScore':
                  //             (int.parse(match.teamBScore) + 1).toString(),
                  //       },
                  //       FirestoreCollections.valorantMatch);
                  // }
                  return hasWon ? result.teamA : result.teamB;
                }
              }
              // Else if safe to assumme that teamB is a red team
              // teamA is a blue team
              // Update the leaderboard
              Map<String, dynamic> redTeamResult =
                  _response['data'][index]['teams']['red'];
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
              return hasWon ? result.teamB : result.teamA;
            }
          }
        }
      }
      return 'unsucessful';
    } catch (err) {
      throw Failure('Something went wrong',
          message: err.toString(),
          location: 'ValorantHenrikdevAPI.getMatchSummaryAndUpdateLeaderboard');
    }
  }
}
