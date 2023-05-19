import 'dart:math';

class SeedingAlgorithm {
  seedTeamsForSingleElimination(List<String> teams) {
    int rounds = (log(teams.length) / log(2)).ceil();
    int teamsPerRound = pow(2, rounds).toInt();

    for (int round = 1; round <= rounds; round++) {
      int matches = teamsPerRound ~/ 2;

      for (int match = 0; match < matches; match++) {
        String teamA;
        String teamB;

        if (match < teams.length) {
          teamA = teams[match];
        } else {
          teamA = 'BYE';
        }

        if (match + matches < teams.length) {
          teamB = teams[match + matches];
        } else {
          teamB = 'BYE';
        }

        // String matchId = generateMatchId(round, match);
        // matchIds.add(matchId);

        // print('Round $round, Match $match: $teamA vs $teamB (Match ID: $matchId)');
      }

      teamsPerRound ~/= 2;
    }
  }
}
