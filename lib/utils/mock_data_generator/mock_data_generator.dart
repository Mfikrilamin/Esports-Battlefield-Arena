import 'dart:math';

import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';

class MockDataGenerator {
  TournamentParticipant generateFakeParticipant(Tournament tournament) {
    Random random = Random();

    // Generate random IDs and dates
    String dateRegister = DateTime.now().toString();
    String tournamentId = tournament.tournamentId; // can be change accordingly

    // Generate random team details
    String participantId = 'Id ${random.nextInt(100)}';
    String teamName = 'Team ${random.nextInt(100)}';
    String country = 'Country ${random.nextInt(10)}';

    // Generate random member and username lists
    List<dynamic> memberList =
        generateRandomMembers(tournament.maxMemberPerTeam);
    List<dynamic> usernameList = generateRandomUsernames(memberList.length);

    // Generate random seeding, isSolo, and hasPay values
    int seeding = 0;
    bool isSolo = false;
    bool hasPay = true;

    // Create the TournamentParticipant object
    TournamentParticipant participant = TournamentParticipant(
      participantId: participantId,
      dateRegister: dateRegister,
      tournamentId: tournamentId,
      teamName: teamName,
      country: country,
      memberList: memberList,
      usernameList: usernameList,
      seeding: seeding,
      isSolo: isSolo,
      hasPay: hasPay,
    );

    return participant;
  }

  List<String> generateRandomMembers(int count) {
    List<String> members = [];

    for (int i = 0; i < count; i++) {
      String member = 'U9fzCVSwFjcDqvLBq7k25UQHvfp2';
      members.add(member);
    }

    return members;
  }

  List<Map<String, dynamic>> generateRandomUsernames(int count) {
    List<Map<String, dynamic>> usernames = [];

    for (int i = 0; i < count; i++) {
      Map<String, dynamic> usernameMap = {};
      usernameMap.putIfAbsent('username', () => 'Twitchstingko');
      usernameMap.putIfAbsent(
          'usernameId', () => 'f1a9f525-54c2-5fdf-a5ad-d51a9b36b57d');
      usernameMap.putIfAbsent('userId', () => 'U9fzCVSwFjcDqvLBq7k25UQHvfp2');
      usernames.add(usernameMap);
    }

    return usernames;
  }
}
