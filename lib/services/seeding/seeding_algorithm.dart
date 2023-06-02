import 'dart:math';
import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/models/apex_match.dart';
import 'package:esports_battlefield_arena/models/apex_match_result.dart';
import 'package:esports_battlefield_arena/models/valorant_match.dart';
import 'package:esports_battlefield_arena/models/player_stats.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/username.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/seeding/seeding.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:esports_battlefield_arena/utils/mock_data_generator/mock_data_generator.dart';
import 'package:logger/logger.dart';

class SeedingAlgorithm extends Seeding {
  final Database _database = locator<Database>();
  final LogService _log = locator<LogService>();

  @override
  Future<bool> seedTeamsForSingleElimination(Tournament tournament) async {
    // check if the tournament is from valorant
    // check if there exist registered participants in the tournament
    try {
      if (tournament.game != GameType.Valorant.name) {
        return false;
      }

      // MockDataGenerator mockDataGenerator = MockDataGenerator();
      // List<TournamentParticipant> fakeTeams = [];
      // for (int i = 0; i < 19; i++) {
      //   fakeTeams.add(mockDataGenerator.generateFakeParticipant());
      // }

      List<TournamentParticipant> teams = [];

      for (int teamIndex = 0;
          teamIndex < tournament.currentParticipant.length;
          teamIndex++) {
        // get participant information
        TournamentParticipant participant = TournamentParticipant.fromJson(
            await _database.get(tournament.currentParticipant[teamIndex],
                FirestoreCollections.tournamentParticipant));
        teams.add(participant);
      }

      // Simple shuffle algorithm
      teams.shuffle(Random());
      _log.debug(teams.map((e) => e.toJson()).toList().toString());

      List<Map<String, dynamic>> matchDataList = await _database.getAllByQuery(
          ['tournamentId', 'round'],
          [tournament.tournamentId, 1],
          FirestoreCollections.valorantMatch);
      List<ValorantMatch> matchList =
          matchDataList.map((e) => ValorantMatch.fromJson(e)).toList();
      matchList.sort((a, b) => a.match.compareTo(b.match));

      for (int match = 0; match < matchList.length; match++) {
        //only assign the team at round 1
        //1 match consist of two team
        //if thre is not enough team, one team would need bye
        //check if there is enough team
        // List<ValorantMatchResult> matchResultList = [];
        // for (int gameResult = 0;
        //     gameResult < matchList[match].resultList.length;
        //     gameResult++) {
        //   ValorantMatchResult result = ValorantMatchResult.fromJson(
        //       await _database.get(matchList[match].resultList[gameResult],
        //           FirestoreCollections.valorantMatchResult));
        //   matchResultList.add(result);
        // }
        // matchResultList.sort((a, b) => a.gameNumber.compareTo(b.ga));
        if (teams.length >= 2) {
          TournamentParticipant teamA = teams.removeLast();
          TournamentParticipant teamB = teams.removeLast();
          // No need to create new result, instead rewrite it in the created result
          // get the result and update it
          for (int game = 0; game < tournament.gamePerMatch; game++) {
            await _database.update(
                matchList[match].resultList[game],
                {
                  'teamA': teamA.teamName,
                  'teamB': teamB.teamName,
                },
                FirestoreCollections.valorantMatchResult);
          }
          await _database.update(
              matchList[match].matchId,
              {
                'teamA': teamA.participantId,
                'teamB': teamB.participantId,
              },
              FirestoreCollections.valorantMatch);
        } else {
          if (teams.isNotEmpty) {
            //assign bye team
            TournamentParticipant lastTeam = teams.removeLast();
            for (int game = 0; game < tournament.gamePerMatch; game++) {
              await _database.update(
                  matchList[match].resultList[game],
                  {
                    'teamA': lastTeam.teamName,
                    'teamB': 'No team',
                  },
                  FirestoreCollections.valorantMatchResult);
            }
            await _database.update(
                matchList[match].matchId,
                {
                  'teamA': lastTeam.participantId,
                  'teamB': 'No team',
                },
                FirestoreCollections.valorantMatch);
          } else {
            break;
          }
        }
      }
      return true;
    } catch (e) {
      _log.debug(e.toString());
      return false;
    }
  }

  @override
  Future<bool> seedTeamsForApex(Tournament tournament) async {
    try {
      // if (tournament.game != GameType.ApexLegend.name ||
      //     tournament.currentParticipant.isEmpty) {
      //   return false;
      // }

      // MockDataGenerator mockDataGenerator = MockDataGenerator();
      // List<TournamentParticipant> fakeTeams = [];
      // for (int i = 0; i < tournament.maxParticipants; i++) {
      //   fakeTeams.add(mockDataGenerator.generateFakeParticipant(tournament));
      // }

      List<String> teamsId = [...tournament.currentParticipant];
      // fakeTeams.map((participant) => participant.participantId).toList();

      // List<String> teamsId = tournament.currentParticipant;
      List<Map<String, dynamic>> matchData = await _database.getAllByQuery(
          ['tournamentId', 'round'],
          [tournament.tournamentId, 1],
          FirestoreCollections.apexMatch);
      List<ApexMatch> matchList =
          matchData.map((data) => ApexMatch.fromJson(data)).toList();

      teamsId.shuffle(Random());
      _log.debug(' teamsId : ${teamsId.toString()}');

      for (int match = 0; match < matchList.length; match++) {
        //if there is no team available then no need to create the result
        if (teamsId.isEmpty) {
          break;
        }
        List<String> teamList = [];
        if (teamsId.length < 20) {
          teamList = [...teamsId.take(teamsId.length)];
          teamsId.removeRange(0, teamsId.length);
          _log.debug('this is executed');
        } else {
          //create 20 team into a list
          teamList = [...teamsId.take(19)];
          teamsId.removeRange(0, 20);
        }

        // for each of the team list, create a match result
        _log.info('Update new result for match $match');
        for (int game = 0; game < tournament.gamePerMatch; game++) {
          //for each of the game in the match, update the team list in the result
          _log.info('Updating team list for game ${game + 1} in match $match');
          _log.info('Team list: $teamList');
          _log.info('resultId: ${matchList[match].resultList[game]}');
          await updateApexResultTeamList(
              matchList[match].resultList[game], teamList);
        }
        await _database.update(
            matchList[match].matchId,
            {
              'teamList': teamList,
            },
            FirestoreCollections.apexMatch);
      }

      return true;
    } on Failure catch (e) {
      _log.debug(e.toString());
      return false;
    } catch (e) {
      _log.debug(e.toString());
      return false;
    }
  }

  @override
  Future<void> generateMatchForSingleElimination(
      Tournament tournament, int gamePerMatch) async {
    final int numberOfGameForNormalMatch;
    final int numberOfGameForFinalMatch;
    MockDataGenerator mockDataGenerator = MockDataGenerator();

    switch (gamePerMatch) {
      case 1:
        numberOfGameForNormalMatch = 1;
        numberOfGameForFinalMatch = 3;
        break;
      case 3:
        numberOfGameForNormalMatch = 3;
        numberOfGameForFinalMatch = 5;
        break;
      default:
        throw const Failure('Argument Error',
            message: 'Invalid gamePerMatch value',
            location: "SeedingAlgorithm.seedTeamsForSingleElimination");
    }
    // List<TournamentParticipant> fakeTeams = [];
    // for (int i = 0; i < 20; i++) {
    //   fakeTeams.add(mockDataGenerator.generateFakeParticipant());
    // }

    // List<TournamentParticipant> teams = fakeTeams;
    int teams = tournament.maxParticipants;
    int totalTeams = teams;

    //Number of rounds per match
    int rounds = (log(teams) / log(2)).ceil();
    List<ValorantMatch> initialRoundMatchList = [];
    List<ValorantMatch> currentRoundmatch = [];

    //loop to create match
    for (int round = 1; round <= rounds; round++) {
      int matchesInRound = (totalTeams / 2).ceil(); //total match per round
      for (int match = 0; match < matchesInRound; match++) {
        ValorantMatch matchInformation = await createNewMatch(
            tournament,
            round,
            match,
            '', //This will store participant Id later
            '', //This will store participant Id later
            round == rounds
                ? numberOfGameForFinalMatch
                : numberOfGameForNormalMatch);
        for (int gameNumber = 0;
            gameNumber <
                (round == rounds
                    ? numberOfGameForFinalMatch
                    : numberOfGameForNormalMatch);
            gameNumber++) {
          ValorantMatchResult result = await createNewValorantResult(
              matchInformation, 'No team', 'No team', gameNumber + 1);
          matchInformation.resultList.add(result.resultId);
        }
        if (round == 1) {
          initialRoundMatchList.add(matchInformation);
        } else {
          currentRoundmatch.add(matchInformation);
        }
        await _database.update(
            matchInformation.matchId,
            {
              'resultList': matchInformation.resultList,
            },
            FirestoreCollections.valorantMatch);
        tournament.matchList.add(matchInformation
            .matchId); //to update tournament collection to store match id list
      }
      //loop to assign next match id
      int j = 0;
      for (int currentMatchIndex = 0;
          currentMatchIndex < currentRoundmatch.length;
          currentMatchIndex++) {
        for (int i = 0; i < 2; i++) {
          if ((i + currentMatchIndex + j) < initialRoundMatchList.length) {
            print('inititalRound ${[
              i + currentMatchIndex + j
            ]} : next match Id ${currentMatchIndex}');
            await _database.update(
                initialRoundMatchList[i + currentMatchIndex + j].matchId,
                {'nextMatchId': currentRoundmatch[currentMatchIndex].matchId},
                FirestoreCollections.valorantMatch);
          }
        }
        j++;
      }

      if (currentRoundmatch.isNotEmpty) {
        initialRoundMatchList = currentRoundmatch;
        currentRoundmatch = [];
      }
      totalTeams = (totalTeams / 2).ceil();
    }

    _database.update(tournament.tournamentId,
        {'matchList': tournament.matchList}, FirestoreCollections.tournament);
  }

  @override
  Future<void> generateMatchForApex(Tournament tournament) async {
    final int maximumTeamPerMatch = 20;
    int numberOfGroups = tournament.maxParticipants ~/ maximumTeamPerMatch;

    int round = 1;
    String lastMatchId = "";
    List<ApexMatch> previousMatchList = [];
    List<ApexMatch> currentMatchList = [];
    while (numberOfGroups > 0) {
      for (int group = 0; group < numberOfGroups; group++) {
        //create 1 match for each group
        ApexMatch matchInformation =
            await createNewApexMatch(tournament, round, group);
        //create match result depending on number of game set in the tournament for each match
        for (int gameResult = 0;
            gameResult < tournament.gamePerMatch;
            gameResult++) {
          ApexMatchResult result =
              await createNewApexResult(matchInformation, [], gameResult + 1);
          matchInformation.resultList.add(result.resultId);
        }
        if (round == 1) {
          previousMatchList.add(matchInformation);
        } else {
          currentMatchList.add(matchInformation);
        }
        tournament.matchList.add(matchInformation
            .matchId); //to update tournament collection to store match id list
      }
      if (round != 1) {
        //assign next matchId
        if (previousMatchList.isNotEmpty) {
          // we will need to pop 2 match from the previous round
          // Check first if the length is greater than 2
          int i = 0;
          ApexMatch? byeMatch;
          if (previousMatchList.length % 2 != 0) {
            //we will need to bring the bye team forward to the next round
            // Priotize the bye team to be the team that played first
            byeMatch = previousMatchList.removeLast();
          }
          while (previousMatchList.isNotEmpty && i < currentMatchList.length) {
            ApexMatch matchA = previousMatchList.removeLast();
            ApexMatch matchB = previousMatchList.removeLast();
            // Assign the next match id
            _database.update(
                matchA.matchId,
                {'nextMatchId': currentMatchList[i].matchId},
                FirestoreCollections.apexMatch);
            _database.update(
                matchB.matchId,
                {'nextMatchId': currentMatchList[i].matchId},
                FirestoreCollections.apexMatch);
            lastMatchId = currentMatchList[i].matchId;
            i++;
          }
          if (byeMatch != null) {
            if (numberOfGroups == 1) {
              //final match
              currentMatchList.add(byeMatch);
            } else {
              //prioritize the bye team to be the team that played first
              currentMatchList.insert(0, byeMatch);
            }
          }
          previousMatchList = [...currentMatchList];
          currentMatchList.clear();
        }
      }
      numberOfGroups ~/= 2;
      round++;
    }
    //If there is excess, assign to the next match
    if (previousMatchList.isNotEmpty) {
      if (previousMatchList.length % 2 == 0) {
        //create final match
        ApexMatch matchInformation =
            await createNewApexMatch(tournament, round, 0);
        //create match result depending on number of game set in the tournament for each match
        for (int gameResult = 0;
            gameResult < tournament.gamePerMatch;
            gameResult++) {
          ApexMatchResult result =
              await createNewApexResult(matchInformation, [], gameResult + 1);
          matchInformation.resultList.add(result.resultId);
        }
        ApexMatch matchA = previousMatchList.removeLast();
        ApexMatch matchB = previousMatchList.removeLast();
        // Assign the next match id
        _database.update(
            matchA.matchId,
            {'nextMatchId': matchInformation.matchId},
            FirestoreCollections.apexMatch);
        _database.update(
            matchB.matchId,
            {'nextMatchId': matchInformation.matchId},
            FirestoreCollections.apexMatch);
      } else {
        //asign the the match next id to the final match
        ApexMatch match1 = previousMatchList.removeLast();
        if (lastMatchId.isNotEmpty) {
          _database.update(match1.matchId, {"nextMatchId": lastMatchId},
              FirestoreCollections.apexMatch);
        }
      }
    }
    await _database.update(tournament.tournamentId,
        {'matchList': tournament.matchList}, FirestoreCollections.tournament);
  }

  Future<List<TournamentParticipant>> getAllParticipantFromTournament(
      Tournament tournament) async {
    List<TournamentParticipant> teams = [];

    for (String participantId in tournament.currentParticipant) {
      TournamentParticipant participant = TournamentParticipant.fromJson(
        await _database.get(
            participantId, FirestoreCollections.tournamentParticipant),
      );
      teams.add(participant);
    }
    return teams;
  }

  Future<ValorantMatch> createNewMatch(
      Tournament tournament,
      int round,
      int match,
      String teamA,
      String teamB,
      int totalNumberOfGameBeingPlayed) async {
    ValorantMatch matchInformation = ValorantMatch(
      matchId: '',
      game: tournament.game,
      round: round,
      match: match,
      teamA: teamA,
      teamB: teamB,
      winner: '',
      loser: '',
      teamAScore: '',
      teamBScore: '',
      nextMatchId: '',
      date: '',
      tournamentId: tournament.tournamentId,
      startTime: '',
      endTime: '',
      hasCompleted: false,
      resultList: [], //List to cater for best of 3/5 for valorant games || Apex only have 1 result
    );

    String? matchId = await _database.add(
        matchInformation.toJson(), FirestoreCollections.valorantMatch);

    matchInformation = ValorantMatch(
      tournamentId: tournament.tournamentId,
      matchId: matchId!,
      game: tournament.game,
      round: round,
      match: match,
      nextMatchId: '',
      teamA: teamA,
      teamB: teamB,
      winner: '',
      loser: '',
      teamAScore: '',
      teamBScore: '',
      date: '',
      startTime: '',
      endTime: '',
      hasCompleted: false,
      resultList: [], //List to cater for best of 3/5 for valorant games || Apex only have 1 result
    );
    return matchInformation;
  }

  Future<ValorantMatchResult> createNewValorantResult(
      ValorantMatch matchInformation,
      String teamNameA,
      String teamNameB,
      int gameNumber) async {
    //create match result
    ValorantMatchResult matchResult = ValorantMatchResult(
      matchId: matchInformation.matchId,
      lobbyId: '',
      gameNumber: gameNumber,
      teamA: teamNameA,
      teamB: teamNameB,
      winner: '',
      loser: '',
      teamAScore: '0',
      teamBScore: '0',
      isCompleted: false,
      playerStats: [],
    );

    String? resultId = await _database.add(
        matchResult.toJson(), FirestoreCollections.valorantMatchResult);
    matchResult = ValorantMatchResult(
      resultId: resultId!,
      matchId: matchInformation.matchId,
      lobbyId: '',
      gameNumber: gameNumber,
      teamA: teamNameA,
      teamB: teamNameB,
      winner: '',
      loser: '',
      teamAScore: '',
      teamBScore: '',
      isCompleted: false,
      playerStats: [],
    );

    return matchResult;
  }

  Future<List<PlayerStats>> createNewValorantplayerStats(
      ValorantMatch matchInformation,
      ValorantMatchResult matchResult,
      TournamentParticipant teamA,
      TournamentParticipant teamB,
      String teamAName,
      String teamBName) async {
    List<PlayerStats> playerStatList = [];
    //create player statistic team A
    if (teamAName != 'BYE') {
      for (Username playerUsername
          in teamA.usernameList.map((e) => Username.fromJson(e)).toList()) {
        PlayerStats playerStat = PlayerStats(
          participantId: teamA.participantId,
          username: playerUsername.username,
          playerId: playerUsername.usernameId,
          matchId: matchInformation.matchId,
          resultId: matchResult.resultId,
          kills: 0,
          assists: 0,
          deaths: 0,
        );

        //add into database
        String? playerStatId = await _database.add(
            playerStat.toJson(), FirestoreCollections.playerStats);

        //update player statistic id
        playerStat = PlayerStats(
          participantId: teamA.participantId,
          playerStatsId: playerStatId!,
          username: playerUsername.username,
          playerId: playerUsername.usernameId,
          matchId: matchInformation.matchId,
          resultId: matchResult.resultId,
          kills: 0,
          assists: 0,
          deaths: 0,
        );

        playerStatList.add(playerStat);
      }
    }

    //create player statistic team B
    if (teamBName != 'BYE') {
      for (Username playerUsername
          in teamB.usernameList.map((e) => Username.fromJson(e)).toList()) {
        PlayerStats playerStat = PlayerStats(
          participantId: teamB.participantId,
          username: playerUsername.username,
          playerId: playerUsername.usernameId,
          matchId: matchInformation.matchId,
          resultId: matchResult.resultId,
          kills: 0,
          assists: 0,
          deaths: 0,
        );

        //add into database
        String? playerStatId = await _database.add(
            playerStat.toJson(), FirestoreCollections.playerStats);

        //update the player statistic id
        playerStat = PlayerStats(
          participantId: teamB.participantId,
          playerStatsId: playerStatId!,
          username: playerUsername.username,
          playerId: playerUsername.usernameId,
          matchId: matchInformation.matchId,
          resultId: matchResult.resultId,
          kills: 0,
          assists: 0,
          deaths: 0,
        );

        playerStatList.add(playerStat);
      }
    }
    return playerStatList;
  }

  List<int> calculateMatchesPerRound(int numOfTeams) {
    final List<int> matchesPerRound = [];

    int remainingTeams = numOfTeams;

    while (remainingTeams > 1) {
      final int matches = (remainingTeams / 2).ceil();
      matchesPerRound.add(matches);
      remainingTeams = matches + (remainingTeams % 2); // Account for byes
    }

    return matchesPerRound;
  }

  Future<ApexMatch> createNewApexMatch(
      Tournament tournament, int round, int group) async {
    ApexMatch matchInformation = ApexMatch(
      tournamentId: tournament.tournamentId,
      nextMatchId: '',
      game: tournament.game,
      round: round,
      group: group,
      date: '',
      startTime: '',
      endTime: '',
      hasCompleted: false,
      resultList: [],
      teamList: [],
    );

    String? matchId = await _database.add(
        matchInformation.toJson(), FirestoreCollections.apexMatch);

    matchInformation = ApexMatch(
      matchId: matchId!,
      game: tournament.game,
      round: round,
      group: group,
      nextMatchId: '',
      date: '',
      startTime: '',
      endTime: '',
      tournamentId: tournament.tournamentId,
      hasCompleted: false,
      resultList: [],
      teamList: [],
    );

    return matchInformation;
  }

  Future<ApexMatchResult> createNewApexResult(
      ApexMatch match, List<String> teamList, int gameNumber) async {
    List<Map<String, dynamic>> results = [];
    for (int participantIndex = 0; participantIndex < 20; participantIndex++) {
      Map<String, dynamic> result = {};
      if (participantIndex < teamList.length) {
        String participantId = teamList[participantIndex];
        TournamentParticipant participant = TournamentParticipant.fromJson(
            await _database.get(
                participantId, FirestoreCollections.tournamentParticipant));
        result = {
          'participantId': participantId,
          'teamName': participant.teamName,
          'kills': 0,
          'placement': 0,
          'points': 0,
          'seed':
              participantIndex, //initialize the seed to the index, this seed wil change later according to the points
        };
      } else {
        result = {
          'participantId': '',
          'teamName': 'No team',
          'kills': 0,
          'placement': 0,
          'points': 0,
          'seed':
              participantIndex, //initialize the seed to the index, this seed wil change later according to the points
        };
      }
      results.add(result);
    }

    ApexMatchResult matchResult = ApexMatchResult(
      matchId: match.matchId,
      lobbyId: '',
      gameNumber: gameNumber,
      completed: false,
      results: results,
    );

    String? resultId = await _database.add(
        matchResult.toJson(), FirestoreCollections.apexMatchResult);

    matchResult = ApexMatchResult(
      resultId: resultId!,
      matchId: match.matchId,
      lobbyId: '',
      gameNumber: gameNumber,
      completed: false,
      results: results,
    );
    return matchResult;
  }

  Future<void> updateApexResultTeamList(
      String resultId, List<String> teamList) async {
    try {
      List<Map<String, dynamic>> results = [];

      for (int participantIndex = 0;
          participantIndex < 20;
          participantIndex++) {
        Map<String, dynamic> result;
        if (participantIndex < teamList.length) {
          String participantId = teamList[participantIndex];
          TournamentParticipant participant = TournamentParticipant.fromJson(
              await _database.get(
                  participantId, FirestoreCollections.tournamentParticipant));
          result = {
            'participantId': participantId,
            'teamName': participant.teamName,
            'kills': 0,
            'placement': 0,
            'points': 0,
            'seed':
                participantIndex, //initialize the seed to the index, this seed wil change later according to the points
          };
        } else {
          result = {
            'participantId': '',
            'teamName': 'No team',
            'kills': 0,
            'placement': 0,
            'points': 0,
            'seed':
                participantIndex, //initialize the seed to the index, this seed wil change later according to the points
          };
        }
        results.add(result);
      }

      //update the team list
      await _database.update(
          resultId, {'results': results}, FirestoreCollections.apexMatchResult);
    } catch (e) {
      _log.info(e.toString());
    }
  }
}
