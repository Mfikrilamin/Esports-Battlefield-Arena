import 'package:esports_battlefield_arena/models/valorant_match.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';

abstract class ValorantDatabase {
  Future<Map<String, dynamic>> verifyPlayer(String userName, String playerTag);
  Future<String> getMatchSummaryAndUpdateLeaderboard(
      ValorantMatch match, ValorantMatchResult result);
}
